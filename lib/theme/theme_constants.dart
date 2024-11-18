import 'package:flutter/material.dart';

ThemeData juniorTesterThemeData = ThemeData(
  primaryColor: Colors.blue,
  // Blue for Junior Tester
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 19) // Blue AppBar for Junior Tester
      ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blue, // Blue buttons
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.blueAccent, // Blue accent for FAB
  ),
  scaffoldBackgroundColor: Colors.white,
  // White background for light theme
  brightness: Brightness.light,
  canvasColor: Colors.blue
);

ThemeData testerLeadThemeData = ThemeData(
  primaryColor: Colors.red,
  // Red for Tester Lead
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.red,
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 19) // Red AppBar for Tester Lead
      ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.red, // Red buttons
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.redAccent, // Red accent for FAB
  ),
  scaffoldBackgroundColor: Colors.white,
  // White background for light theme
  brightness: Brightness.light,
  canvasColor: Colors.red
);

ThemeData adminThemeData = ThemeData(
  primaryColor: Colors.grey,
  // Grey for Admin (default)
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.grey, // Grey AppBar for Admin
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.grey, // Grey buttons
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.grey, // Grey accent for FAB
  ),
  scaffoldBackgroundColor: Colors.white,
  // White background for light theme
  brightness: Brightness.light,
);
