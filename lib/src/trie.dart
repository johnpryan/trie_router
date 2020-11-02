import 'trie_node.dart';

/// A trie
class Trie<K, V> {
  final TrieNode<K, V> root;

  Trie() : root = TrieNode<K, V>(null);
}
