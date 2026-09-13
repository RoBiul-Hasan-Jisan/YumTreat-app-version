import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_profile.dart';
import 'api_client.dart';

/// Friendlier text for the Firebase error codes people actually hit —
/// mirrors friendlyAuthError() in frontend/context/AuthContext.jsx.
String friendlyAuthError(Object err) {
  String code = '';
  if (err is FirebaseAuthException) code = err.code;
  const map = {
    'email-already-in-use': 'An account with this email already exists.',
    'invalid-email': "That email address doesn't look right.",
    'weak-password': 'Password should be at least 6 characters.',
    'user-not-found': 'No account found with that email.',
    'wrong-password': 'Incorrect email or password.',
    'invalid-credential': 'Incorrect email or password.',
    'popup-closed-by-user': 'Sign-in was closed before completing.',
    'sign_in_canceled': 'Sign-in was closed before completing.',
    'too-many-requests': 'Too many attempts. Please wait a moment and try again.',
  };
  return map[code] ?? (err is FirebaseAuthException ? err.message : null) ?? 'Something went wrong. Please try again.';
}

/// Auth happens entirely client-side against Firebase (no JWT, no password
/// stored on our backend) — mirrors frontend/context/AuthContext.jsx and
/// frontend/lib/firebase.js. The backend only ever verifies the Firebase ID
/// token (see backend/src/middleware/auth.js) and syncs a local profile.
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _dio = ApiClient.instance.dio;

  // Created lazily, not in the constructor: on web, GoogleSignIn's
  // constructor immediately requires a configured OAuth client id (see
  // web/index.html) and throws if it's missing — which would crash the
  // whole app on startup even for people who never tap "Continue with
  // Google". Deferring construction means email/password auth always
  // works regardless of whether Google Sign-In has been configured yet.
  GoogleSignIn? _googleSignIn;
  GoogleSignIn get _google => _googleSignIn ??= GoogleSignIn();

  Stream<User?> get idTokenChanges => _auth.idTokenChanges();
  User? get currentUser => _auth.currentUser;

  /// GET /api/auth/account — also doubles as the "sync" call the app makes
  /// right after a Firebase sign-in; requireAuth on the backend provisions
  /// the local user record on first call.
  Future<UserProfile?> syncProfile() async {
    try {
      final res = await _dio.get('/auth/account');
      final data = res.data as Map<String, dynamic>;
      return UserProfile.fromJson(data['profileDetails'] as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (err) {
      throw Exception(friendlyAuthError(err));
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (name.isNotEmpty) {
        await cred.user?.updateDisplayName(name);
      }
    } catch (err) {
      throw Exception(friendlyAuthError(err));
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        // user cancelled the picker — mirrors popup-closed-by-user
        throw Exception('Sign-in was closed before completing.');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } catch (err) {
      throw Exception(friendlyAuthError(err));
    }
  }

  Future<void> logout() async {
    // Only touch Google Sign-In if it was actually used this session —
    // constructing it fresh here just to sign out would hit the same
    // "ClientID not set" crash on web for people who only ever used
    // email/password.
    if (_googleSignIn != null) {
      await _googleSignIn!.signOut();
    }
    await _auth.signOut();
  }
}
