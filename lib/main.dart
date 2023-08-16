import 'package:flutter/material.dart';
import 'package:tracker_app/pages/home_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // const
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      // theme: ThemeData(primarySwatch: Colors.green),
    );
  }
}
