import 'package:flutter/material.dart';
import 'package:prayer_app/view/home_card_screen.dart';
import 'package:prayer_app/view/home_screen.dart';
import 'package:prayer_app/view/monthly_prayers_screen.dart';
import 'package:prayer_app/view/monthly_screen.dart';
import 'package:prayer_app/view/splash_screen.dart';
import 'package:prayer_app/view_model/auth_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
