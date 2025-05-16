import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_assessment/view/auth/splash_screen.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../../utils/themes.dart';
import 'firebase_options.dart';

final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.system);

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

  @override
   Widget build(BuildContext context) {
     return GestureDetector(
       behavior: HitTestBehavior.opaque,
       onTap: () {
         FocusManager.instance.primaryFocus?.unfocus();
       },
       child: ValueListenableBuilder<ThemeMode>(
         valueListenable: themeNotifier,
         builder: (context, mode, _) {
           return ScreenUtilInit(
             designSize: const Size(450.0, 700.0),
             minTextAdapt: true,
             splitScreenMode: true,
             builder: (BuildContext context, Widget? child) {
               ScreenUtil.init(context);
               return MaterialApp(
                 localizationsDelegates: const [
                   GlobalMaterialLocalizations.delegate,
                   GlobalCupertinoLocalizations.delegate,
                   GlobalWidgetsLocalizations.delegate,
                   FlutterQuillLocalizations.delegate,
                 ],
                 title: 'Notes App',
                 themeMode: mode,
                 theme: AppTheme.lightTheme,
                 darkTheme: AppTheme.darkTheme,
                 debugShowCheckedModeBanner: false,
                 home: const SplashView(),
               );
             },
           );
         },
       ),
     );
   }

}
