import 'package:go_router/go_router.dart';
import '../screens/list_screen.dart';
import '../screens/detail_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ListScreen(),
    ),
    GoRoute(
      path: '/detail/:breed',
      builder: (context, state) {
        final breed = state.pathParameters['breed']!;
        return DetailScreen(breed: breed);
      },
    ),
  ],
);