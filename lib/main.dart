import 'package:crypto_app/presentation/pages/splash/startup_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypto App',
      theme: ThemeData.dark(),
      home: const StartupWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}