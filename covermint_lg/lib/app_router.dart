import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/auth/auth_state.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/register/data/covermint_repository.dart';
import 'features/register/presentation/step1_screen.dart';
import 'features/register/presentation/step2_screen.dart';
import 'features/sell/product_detail_screen.dart';
import 'features/sell/sell_hub_screen.dart';
import 'features/tabs/leads_tab.dart';
import 'features/tabs/performance_tab.dart';
import 'features/tabs/renewals_tab.dart';
import 'features/welcome/welcome_screen.dart';

// ignore: unused_element
bool _isPublic(String location) {
  return location == '/welcome' ||
      location == '/register' ||
      location.startsWith('/register/') ||
      location == '/login';
}

GoRouter createRouter(AuthState authState, CovermintRepository repository) {
  return GoRouter(
    initialLocation: '/welcome',
    refreshListenable: authState,
    redirect: (context, state) {
      if (!authState.isReady) return null;
      // Placeholder mode: no auth guard - allow all navigation for UI preview
      // Uncomment below for real auth:
      // if (!authState.isAuthed && !_isPublic(location)) return '/login';
      // if (authState.isAuthed && (location == '/login' || location == '/register' || location == '/welcome')) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/welcome',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const WelcomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: Step1Screen(repository: repository),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: '/register/:draftId',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: Step2Screen(repository: repository, draftId: state.pathParameters['draftId']!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)), child: child),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginScreen(repository: repository, authState: authState),
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(opacity: animation, child: child),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ScaffoldWithNavBar(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/dashboard', builder: (context, state) => DashboardScreen(repository: repository, authState: authState))]),
          StatefulShellBranch(routes: [GoRoute(path: '/sell', builder: (context, state) => SellHubScreen(repository: repository), routes: [GoRoute(path: ':category', builder: (context, state) => ProductDetailScreen(category: state.pathParameters['category'] ?? 'insurance'))])]),
          StatefulShellBranch(routes: [GoRoute(path: '/leads', builder: (context, state) => LeadsTab(repository: repository))]),
          StatefulShellBranch(routes: [GoRoute(path: '/renewals', builder: (context, state) => RenewalsTab(repository: repository))]),
          StatefulShellBranch(routes: [GoRoute(path: '/performance', builder: (context, state) => PerformanceTab(repository: repository))]),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200))),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _goBranch,
          height: 64,
          backgroundColor: Colors.white,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Dashboard'),
            NavigationDestination(icon: Icon(Icons.storefront_outlined), selectedIcon: Icon(Icons.storefront), label: 'Sell'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Leads'),
            NavigationDestination(icon: Icon(Icons.autorenew_outlined), selectedIcon: Icon(Icons.autorenew), label: 'Renewal'),
            NavigationDestination(icon: Icon(Icons.insights_outlined), selectedIcon: Icon(Icons.insights), label: 'Performance'),
          ],
        ),
      ),
    );
  }
}
