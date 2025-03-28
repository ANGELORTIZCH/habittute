import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: Colors.grey.shade900, // Usar 'surface' en lugar de 'background'
    primary: Colors.grey.shade600,
    secondary: const Color.fromARGB(255, 44, 44, 44),
    tertiary: Colors.grey.shade800,
    inversePrimary: Colors.grey.shade300,
  ),
);
