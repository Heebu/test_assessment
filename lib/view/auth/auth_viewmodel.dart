import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';


class AuthViewModel extends BaseViewModel {
  User? currentUser;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isUserLoggedIn() async {
    await Future.delayed(const Duration(seconds: 2));
    return _auth.currentUser != null;
  }

  Future<void> signInWithGoogle() async {
    setBusy(true);
    currentUser = await AuthService().signInWithGoogle();
    setBusy(false);
  }

  Future<void> signInEmail() async {
    setBusy(true);
    currentUser = await AuthService().signInEmail(emailController.text.trim(), passwordController.text.trim());
    setBusy(false);
  }

  Future<void> signOut() async {
    await AuthService().signOut();
    currentUser = null;
    notifyListeners();
  }

  bool get isLoggedIn => currentUser != null;
}
