import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_assessment/view/auth/splash_screen.dart';

import '../../utils/themes.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const NotesApp());
}

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {

   ThemeMode _themeMode = ThemeMode.system;

  // void _toggleTheme(bool isDark) {
  //   setState(() {
  //     _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  //   });
  // }


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ScreenUtilInit(
        designSize: const Size(450.0, 700.0),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          ScreenUtil.init(context);
          return MaterialApp(
            title: 'Notes App',
            themeMode: _themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            home: const
            SplashView(),
          );
        },
      ),
    );
  }
}
