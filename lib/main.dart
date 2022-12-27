import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'gen/colors.gen.dart';
import 'gen/fonts.gen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  runApp(const ProviderScope(child: HotelApp()));
}

class HotelApp extends StatelessWidget {
  const HotelApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Hotel App UI',
      theme: ThemeData(
        fontFamily: FontFamily.workSans,
        primarySwatch: ColorName.primarySwatch,
      ),
      home: const HomeScreen(),
    );
  }
}
