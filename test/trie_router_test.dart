import 'package:trie_router/trie_router.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Trie trie;

    setUp(() {
      trie = Trie();
    });

    test('First Test', () {
      var isNew = trie.add(['users', ':id'], 100);
      expect(isNew, isTrue);
      isNew = trie.add(['users', ':id'], 300);
      expect(isNew, isFalse);
      expect(trie.contains(['users', ':id']), isTrue);
      expect(trie.contains(['users']), isFalse);
    });
  });
}
