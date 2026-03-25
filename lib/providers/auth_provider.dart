import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../shared_prefs/shared_preference.dart';


class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;


  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check login status from SharedPreferences
  Future<void> checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    bool status = await SharedPref.getLoginStatus();

    _isLoggedIn = status;
    _isLoading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _auth.signOut();
    await _googleSignIn.signOut();
    await SharedPref.logout();

    _isLoggedIn = false;

    _isLoading = false;
    notifyListeners();
  }

  Future<User?> googleLogin() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _googleSignIn.signOut();

      GoogleSignInAccount? googleAccount =
      await _googleSignIn.signIn();

      if (googleAccount == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
      await googleAccount.authentication;

      final AuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        _isLoggedIn = true;

        await SharedPref.saveLoginStatus(true);
        await SharedPref.saveUserName(user.displayName ?? "");
        await SharedPref.saveUserEmail(user.email ?? "");
      }

      _isLoading = false;
      notifyListeners();

      return user;
    } catch (e) {
      _errorMessage = "Google login failed: $e";
      _isLoggedIn = false;

      _isLoading = false;
      notifyListeners();

      return null;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

}
