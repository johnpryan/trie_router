/// A node in the trie
class TrieNode<K, V> {
  final Map<K, TrieNode<K, V>> _children;
  final V value;

  TrieNode(this.value) : _children = {};

  bool contains(K key) {
    return _children.containsKey(key);
  }

  void add(K key, V value) {
    _children[key] = TrieNode<K, V>(value);
  }

  TrieNode<K, V> get(K key) {
    return _children.containsKey(key) ? _children[key] : null;
  }
}
