import 'package:flutter/material.dart';

class PColor {
  static final PColor _instance = PColor._internal();
  factory PColor() => _instance;
  PColor._internal();

  // Primary brand color 
  Color primary = const Color(0xFF3D5CFF);
  
  // Status colors (Stock Data)
  Color success = const Color(0xFF2EBD85); 
  Color danger = const Color(0xFFF6465D);  
  Color warning = const Color(0xFFFFD93D);

  // Light Mode Colors
  Color backgroundLight = const Color(0xFFF8F9FA); // Main app background
  Color containerLight = const Color(0xFFFFFFFF);  // Cards, bottom nav, etc.
  Color textPrimaryLight = const Color(0xFF151316); 
  Color textSecondaryLight = const Color(0xFF8288A2);

  // Dark Mode Colors
  Color backgroundDark = const Color(0xFF0D0D12);  // Deep dark background
  Color containerDark = const Color(0xFF1C1C22);   // Slightly elevated dark for cards
  Color textPrimaryDark = const Color(0xFFFFFFFF);
  Color textSecondaryDark = const Color(0xFFA0A5BA);

  // Neutral colors
  Color white = const Color(0xFFFFFFFF);
  Color black = const Color(0xFF000000);
  Color divider = const Color(0xFF2C2C35); // For potential list separators
}