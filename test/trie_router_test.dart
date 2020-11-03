import 'package:trie_router/src/errors.dart';
import 'package:trie_router/src/trie.dart';
import 'package:trie_router/src/trie_router.dart';
import 'package:trie_router/trie_router.dart';

import 'package:test/test.dart';

void main() {
  group('Trie', () {
    Trie trie;

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
    TrieRouter routerTrie;

    setUp(() {
      routerTrie = TrieRouter<int>();
    });

    test('add() and contains()', () {
      routerTrie.add(['users', ':id'], 100);
      expect(routerTrie.contains(['users', ':id']), isTrue);
    });

    test('get()', () {
      routerTrie.add(['users', 'all'], 100);
      expect(routerTrie.get(['users', 'all']), equals(TrieRouterData(100, {})));
    });

    test('get() returns a map of keys prefixed with a colon', () {
      routerTrie.add(['users', ':id'], 100);
      expect(routerTrie.contains(['users', '123']), isTrue);
    });

    test('throws if there are multiple keys prefixed with a colon', () {
      routerTrie.add(['users', ':id'], 100);
      expect(() => routerTrie.add(['users', ':foo'], 100),
          throwsA(isA<ConflictingPathError>()));
      expect(() => routerTrie.add(['users', ':id'], 100),
          isNot(throwsA(isA<ConflictingPathError>())));
    });

    test('complex example', () {
      routerTrie.add([], 0);
      routerTrie.add(['users', ':id'], 1);
      routerTrie.add(['users', ':id', 'foo'], 2);
      routerTrie.add(['users', 'all'], 3);

      expect(routerTrie.get([]), equals(TrieRouterData(0, {})));
      expect(routerTrie.get(['users', '123']),
          equals(TrieRouterData(1, {':id': '123'})));
      expect(routerTrie.get(['users', '456', 'foo']),
          equals(TrieRouterData(2, {':id': '456'})));
      expect(routerTrie.get(['users', 'all']), equals(TrieRouterData(3, {})));
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
