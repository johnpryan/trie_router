import 'package:trie_router/trie_router.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    Trie trie;

    setUp(() {
      trie = Trie();
    });

    test('First Test', () {
      expect(trie, isNotNull);
    });
  });
}
