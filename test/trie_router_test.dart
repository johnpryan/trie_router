import 'package:trie_router/src/errors.dart';
import 'package:trie_router/src/trie.dart';
import 'package:trie_router/src/trie_router.dart';
import 'package:trie_router/trie_router.dart';

import 'package:test/test.dart';

void main() {
  group('Trie', () {
    late Trie trie;

    setUp(() {
      trie = Trie();
    });

    test('add() and contains()', () {
      var isNew = trie.add(['users', ':id'], 100);
      expect(isNew, isTrue);

      isNew = trie.add(['users', ':id'], 300);
      expect(isNew, isFalse);

      expect(trie.contains(['users', ':id']), isTrue);
      expect(trie.contains(['users']), isFalse);
    });
  });

  group('RouterTrie', () {
    late TrieRouter routerTrie;

    setUp(() {
      routerTrie = TrieRouter<int>();
    });

    test('addPathComponents() and contains()', () {
      routerTrie.addPathComponents(['users', ':id'], 100);
      expect(routerTrie.contains(['users', ':id']), isTrue);
    });

    test('add() and contains()', () {
      routerTrie.add('users/:id', 100);
      expect(routerTrie.contains(['users', ':id']), isTrue);
    });

    test('get()', () {
      routerTrie.addPathComponents(['users', 'all'], 100);
      expect(
          routerTrie.get('users/all'), equals(TrieRouterData<int?>(100, {})));
    });

    test('get() returns a map of keys prefixed with a colon', () {
      routerTrie.addPathComponents(['users', ':id'], 100);
      expect(routerTrie.contains(['users', '123']), isTrue);
    });

    test('throws if there are multiple keys prefixed with a colon', () {
      routerTrie.addPathComponents(['users', ':id'], 100);
      expect(() => routerTrie.addPathComponents(['users', ':foo'], 100),
          throwsA(isA<ConflictingPathError>()));
      expect(() => routerTrie.addPathComponents(['users', ':id'], 100),
          isNot(throwsA(isA<ConflictingPathError>())));
    });

    test('complex example', () {
      routerTrie.addPathComponents([], 0);
      routerTrie.addPathComponents(['users', ':id'], 1);
      routerTrie.addPathComponents(['users', ':id', 'foo'], 2);
      routerTrie.addPathComponents(['users', 'all'], 3);

      expect(routerTrie.get(''), equals(TrieRouterData<int?>(0, {})));
      expect(routerTrie.get('users/123'),
          equals(TrieRouterData<int?>(1, {':id': '123'})));
      expect(routerTrie.get('users/456/foo'),
          equals(TrieRouterData<int?>(2, {':id': '456'})));
      expect(routerTrie.get('users/all'), equals(TrieRouterData<int?>(3, {})));
    });

    test('null-checks when a sibling is null', () {
      routerTrie.addPathComponents(['users'], 1);
      routerTrie.addPathComponents(['users', ':id'], 2);
      expect(routerTrie.get('users/123'),
          equals(TrieRouterData<int?>(2, {':id': '123'})));
    });

    test('query parameters', () {
      routerTrie.addPathComponents(['users'], 1);
      routerTrie.addPathComponents(['users', ':id'], 2);
      expect(routerTrie.get('users/123?foo=bar'),
          equals(TrieRouterData<int?>(2, {':id': '123'})));
    });
  });

  group('RouterGetResult', () {
    test('equals and hashCode', () {
      var a = TrieRouterData('foo', {':id': '123'});
      var b = TrieRouterData('foo', {':id': '123'});
      expect(a, equals(b));
      b = TrieRouterData('foo', {':id': '100'});
      expect(a, isNot(equals(b)));
    });
  });
}
