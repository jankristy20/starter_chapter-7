import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/models.dart';
import '../screens/screens.dart';

class AppRouter {
  // 1
  final AppStateManager appStateManager;
  // 2
  final ProfileManager profileManager;
  // 3
  final GroceryManager groceryManager;
  AppRouter(
    this.appStateManager,
    this.profileManager,
    this.groceryManager,
  );
  // 4
  late final router = GoRouter(
    // 5
    debugLogDiagnostics: true,
    // 6
    refreshListenable: appStateManager,
    // 7
    initialLocation: '/login',
    // 8
    routes: [
      // TODO: Add Login Route
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // TODO: Add Onboarding Route
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // TODO: Add Home Route
      GoRoute(
        name: 'home',
        // 1
        path: '/:tab',
        builder: (context, state) {
          // 2
          final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
          // 3
          return Home(
            key: state.pageKey,
            currentTab: tab,
          );
        },
        // 3
        routes: [
          // TODO: Add Item Subroute
          GoRoute(
            name: 'item',
            // 1
            path: 'item/:id',
            builder: (context, state) {
              // 2
              final itemId = state.pathParameters['id'] ?? '';
              // 3
              final item = groceryManager.getGroceryItem(itemId);
              // 4
              return GroceryItemScreen(
                originalItem: item,
                onCreate: (item) {
                  // 5
                  groceryManager.addItem(item);
                },
                onUpdate: (item) {
                  // 6
                  groceryManager.updateItem(item);
                },
              );
            },
          ),
          // TODO: Add Profile Subroute
          GoRoute(
            name: 'profile',
            // 1
            path: 'profile',
            builder: (context, state) {
              // 2
              final tab = int.tryParse(state.pathParameters['tab'] ?? '') ?? 0;
              // 3
              return ProfileScreen(
                user: profileManager.getUser,
                currentTab: tab,
              );
            },
            // 4
            routes: [
              // TODO: Add Webview subroute
              GoRoute(
 name: 'rw',
 path: 'rw',
 builder: (context, state) => const WebViewScreen(),
),
            ],
          ),
        ],
      ),
    ],
    // TODO: Add Error Handler
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(
              state.error.toString(),
            ),
          ),
        ),
      );
    },
    // TODO: Add Redirect Handler
    redirect: (_, state) {
      // 1
      final loggedIn = appStateManager.isLoggedIn;
      // 2
      final loggingIn = state.location == '/login';
      // 3
      if (!loggedIn) return loggingIn ? null : '/login';
      // 4
      final isOnboardingComplete = appStateManager.isOnboardingComplete;
      // 5
      final onboarding = state.location == '/onboarding';
      // 6
      if (!isOnboardingComplete) {
        return onboarding ? null : '/onboarding';
      }
      // 7
      if (loggingIn || onboarding) return '/${FooderlichTab.explore}';
      // 8
      return null;
    },
  );
}
