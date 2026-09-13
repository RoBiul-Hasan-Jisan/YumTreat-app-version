import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/common.dart';
import '../signin_screen.dart';

/// Mirrors components/AdminGuard.jsx — blocks non-admins from the
/// wrapped screen, with sign-in / not-authorized states.
class AdminGuard extends StatelessWidget {
  final Widget child;
  const AdminGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.ready) return const Scaffold(body: Loader());

    if (!auth.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          title: 'Sign in required',
          subtitle: 'You need an admin account to view this page.',
          action: ElevatedButton(
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignInScreen())),
            child: const Text('Sign in'),
          ),
        ),
      );
    }

    if (!auth.isAdmin) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyState(
          title: 'Admin access required',
          subtitle: "Your account doesn't have permission to view this page.",
        ),
      );
    }

    return child;
  }
}
