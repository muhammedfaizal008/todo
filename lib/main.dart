// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todo/controller/first_screen_controller.dart';
import 'package:todo/view/first_screen/first_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirstScreenController.initialiseDatabase();
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstScreen(),
    );
  }
}