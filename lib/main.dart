import 'package:flutter/material.dart';
import 'package:quiz_app/ui/screens/home/home_screen.dart';
import 'package:quiz_app/ui/screens/quiz_result/quiz_result_screen.dart';

void main() => runApp(const MyApp());

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
