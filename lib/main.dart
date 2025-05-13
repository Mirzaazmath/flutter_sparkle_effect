import 'package:flutter/material.dart';
import 'package:flutter_sparkle_effect/sparkle/sparkle_screen.dart';
void main(){
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sparkling(),
    );
  }
}
