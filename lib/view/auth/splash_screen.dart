import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/home.dart';
import 'login.dart';




class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show the splash screen while checking the user's login status
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      height: 400.h,
                      width: 400.w,
                      child: FlutterLogo(),
                    ),
                  ),
                  Text(
                    'Notes App',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),

                  SizedBox(
                    height: 30.h,
                  ),
                ],
              ),
            ),
          );
        } else {
          // Check if the user is logged in or not
          if (snapshot.hasData && snapshot.data != null) {
            return const HomeScreen();
            // User is logged in, navigate to the Home screen
          } else {
            // User is not logged in, navigate to the Sign In screen
            return const LoginView();
            // return const HomeScreen();

          }
        }
      },
    );
  }
}
