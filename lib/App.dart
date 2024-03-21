import 'package:blood_pressure_bpm_tracker/MainPage.dart';
import 'package:flutter/material.dart';

// **************************************************************************
// Class of main app properties
// **************************************************************************

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Pressure BPM Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color.fromARGB(255, 201, 187, 170),
      ),

      home: const DefaultTabController(
        length: 3, 
        child: MainPage()
      ),
    );
  }
}