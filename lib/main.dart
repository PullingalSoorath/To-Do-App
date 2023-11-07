import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:todoapp/home_page.dart';

void main() async {
  WidgetsFlutterBinding();

  await Hive.initFlutter();
  await Hive.openBox('boxname');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.light(
            primary: Colors.black,
            background: Colors.purple[200]!,
            primaryContainer: const Color.fromARGB(255, 223, 100, 245),
            onSecondary: Colors.purpleAccent),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: Colors.white,
          background: Colors.purple[900]!,
          primaryContainer: Colors.purple,
          onSecondary: Colors.deepPurple,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
