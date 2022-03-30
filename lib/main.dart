import 'package:flutter/material.dart';
import 'package:quiz_app/services/service_locator.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';

void main() {
  ServiceLocator.setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: HomeScreen(),
    );
  }
}
