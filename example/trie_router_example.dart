import 'package:trie_router/trie_router.dart';

typedef RouteHandler = void Function(Map<String, String> parameters);

TrieRouter router = TrieRouter<RouteHandler>();

void main() {
  // Add routes
  addRoute('', (_) => print('Displaying home page'));
  addRoute('users/:id', (params) => print('Displaying user ${params[":id"]}'));
  addRoute('users/:id/settings',
      (params) => print('Displaying settings for user ${params[":id"]}'));

  // Handle routes
  handlePath('');
  handlePath('users/123');
  handlePath('users/123/settings');
}

void addRoute(String s, RouteHandler handler) {
  router.add(s, handler);
}

void handlePath(String s) {
  var element = router.get(s)!;
  element.value(element.parameters);
}
