import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';
import '../services/auth_service.dart';

/// Mirrors frontend/context/AuthContext.jsx — listens for Firebase
/// sign-in/out AND silent token refreshes, and keeps a synced backend
/// profile (which carries the role) alongside the raw Firebase user.
class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();
  StreamSubscription<User?>? _sub;

  User? firebaseUser;
  UserProfile? profile;
  bool ready = false;

  bool get isAuthenticated => firebaseUser != null;
  bool get isAdmin => profile?.isAdmin ?? false;

  AuthProvider() {
    _sub = _service.idTokenChanges.listen((user) async {
      firebaseUser = user;
      if (user != null) {
        profile = await _service.syncProfile();
      } else {
        profile = null;
      }
      ready = true;
      notifyListeners();
    });
  }

  Future<void> refreshProfile() async {
    profile = await _service.syncProfile();
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    await _service.login(email, password);
    await refreshProfile();
  }

  Future<void> register(String email, String password, String name) async {
    await _service.register(email, password, name);
    await refreshProfile();
  }

  Future<void> loginWithGoogle() async {
    await _service.loginWithGoogle();
    await refreshProfile();
  }

  Future<void> logout() async {
    await _service.logout();
    profile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
