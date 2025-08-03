import 'package:controlador_vicios/components/components.dart';
import 'package:controlador_vicios/pages/auth/login_page.dart';
import 'package:controlador_vicios/pages/splash_screen/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    // prinnt("🔥 Firebase inicializado com sucesso!");
  } catch (e) {
    // print("❌ Erro ao inicializar o Firebase: $e");
  }


  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/login': (context) => LoginPage(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: appColors.secondary
      ),
        home: SplashScreen(),
    );
  }
}
