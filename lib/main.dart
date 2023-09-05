import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tracker_app/pages/home_page.dart';

void main() async {
  // local database setup
  await Hive.initFlutter();
  await Hive.openBox("Tracker_DB");
  
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
