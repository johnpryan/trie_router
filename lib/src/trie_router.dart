import 'package:collection/collection.dart';
import 'package:trie_router/src/errors.dart';

import 'trie.dart';

import 'package:quiver/core.dart';

class TrieRouter<T> {
  final Trie<String, T> _trie;

  TrieRouter() : _trie = Trie();

  /// Throws a [ConflictingPathError] if there is a conflict.
  ///
  /// It is an error to add two segments prefixed with ':' at the same index.
  bool add(Iterable<String> pathSegments, T value) {
    var list = List<String>.from(pathSegments);
    var current = _trie.root;
    var isNew = false;

    // Allow an empty list of path segments to associate a value at the root
    if (pathSegments.isEmpty) {
      _trie.root.value = value;
    }

    // Work downwards through the trie, adding nodes as needed, and keeping
    // track of whether we add any nodes.
    for (var i = 0; i < list.length; i++) {
      var pathSegment = list[i];

      // Throw an error when two segments start with ':' at the same index.
      if (pathSegment.startsWith(':') &&
          current.containsWhere((k) => k.startsWith(':')) &&
          !current.containsWhere((k) => k == pathSegment)) {
        throw ConflictingPathError(
            list,
            List<String>.from(list).sublist(0, i)
              ..add(current.getWhere((k) => k.startsWith(':')).key));
      }

      if (!current.contains(pathSegment)) {
        isNew = true;
        current.add(pathSegment, value);
      }

      current = current.get(pathSegment);
    }

    // Explicitly mark the end of a list of path segments. Otherwise, we might
    // say a path segment is present if it is a prefix of a different, longer
    // word that was added earlier.
    if (!current.contains(null)) {
      isNew = true;
      current.add(null, null);
    }
    return isNew;
  }

  bool contains(Iterable<String> pathSegments) {
    var current = _trie.root;

    for (var segment in pathSegments) {
      if (current.contains(segment)) {
        current = current.get(segment);
      } else if (current.containsWhere((k) => k.startsWith(':'))) {
        // If there is a segment that starts with `:`, we should match any
        // route.
        current = current.getWhere((k) => k.startsWith(':'));
      } else {
        return false;
      }
    }

    return current.contains(null);
  }

  TrieRouterData<T> get(Iterable<String> pathSegments) {
    var parameters = <String, String>{};
    var current = _trie.root;

    for (var segment in pathSegments) {
      if (current.contains(segment)) {
        current = current.get(segment);
      } else if (current.containsWhere((k) => k.startsWith(':'))) {
        // If there is a segment that starts with `:`, we should match any
        // route.
        current = current.getWhere((k) => k != null && k.startsWith(':'));

        // Add the current segment to the parameters. E.g. ':id': '123'
        parameters[current.key] = segment;
      } else {
        return null;
      }
    }
    return TrieRouterData(current.value, parameters);
  }
}

class TrieRouterData<T> {
  final T value;
  final Map<String, String> parameters;

  TrieRouterData(this.value, this.parameters);

  @override
  int get hashCode => hash2(value, DeepCollectionEquality().hash(parameters));

  @override
  operator ==(Object other) {
    return other is TrieRouterData<T> &&
        value == other.value &&
        DeepCollectionEquality().equals(parameters, other.parameters);
  }

  String toString() {
    return 'RouterGetResult value: $value paramters $parameters';
  }
}
