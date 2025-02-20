import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordquest/pages/enternamepage.dart';
import 'package:wordquest/pages/welcomepage.dart';

// Global notifier to manage theme state (default is true for Night Mode)
ValueNotifier<bool> isNightMode = ValueNotifier<bool>(true);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget { 
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userName = '';

  // Function to get the saved name from SharedPreferences
  Future<void> _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ??
          ''; // Default to empty string if no name saved
    });
  }

  // Callback function to save the name
  Future<void> _saveName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
    setState(() {
      userName = name; // Update userName in state
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserName(); // Load the username when the app starts
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isNightMode,
      builder: (context, isNight, child) {
        return MaterialApp(
          title: 'Word Quest',
          debugShowCheckedModeBanner: false,
          theme: isNight
              ? ThemeData(
                  brightness: Brightness.dark,
                  primaryColor: Colors.black,
                  scaffoldBackgroundColor: Colors.black,
                  appBarTheme: const AppBarTheme(
                    color: Color(0xFF1C1C64),
                    iconTheme: IconThemeData(color: Colors.white),
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
                    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                )
              : ThemeData(
                  brightness: Brightness.light,
                  primaryColor: Colors.white,
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: const AppBarTheme(
                    color: Color(0xFF7D7DF0),
                    iconTheme: IconThemeData(color: Colors.black),
                    titleTextStyle: TextStyle(
                      color: Color(0xFF3E3D3D),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textTheme: const TextTheme(
                    bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
                    bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                ),
          home: userName.isEmpty
              ? Enternamepage(
                  onSubmitName: _saveName, // Pass the callback to save name
                  isNightMode: isNight,
                  onThemeChanged: (newMode) {
                    setState(() {
                      isNightMode.value = newMode;
                    });
                  },
                )
              : WelcomePage(
                  userName: userName), // Show WelcomePage if username is set
        );
      },
    );
  }
}
