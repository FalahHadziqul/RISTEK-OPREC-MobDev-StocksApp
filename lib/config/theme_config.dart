import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/themes/color_theme.dart';

final _color = PColor();

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: _color.primary,
      scaffoldBackgroundColor: _color.backgroundLight,

      // Matching RiSTOCK AppBar design
      appBarTheme: AppBarTheme(
        backgroundColor: _color.backgroundLight,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: _color.textPrimaryLight),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _color.textPrimaryLight,
        ),
      ),

      // Theme for "My Watchlist" and "Trending" cards
      cardTheme: CardThemeData(
        color: _color.containerLight,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Styling for the search bar
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _color.containerLight,
        hintStyle: GoogleFonts.poppins(color: _color.textSecondaryLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: TextStyle(
          color: _color.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: _color.textPrimaryLight),
        bodySmall: TextStyle(color: _color.textSecondaryLight),
      ),

      colorScheme: ColorScheme.light(
        primary: _color.primary,
        surface: _color.containerLight,
        error: _color.danger,
        onSurface: _color.textPrimaryLight,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _color.containerLight,
        indicatorColor: _color.primary.withValues(alpha: 0.16),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: _color.primary);
          }
          return IconThemeData(color: _color.textSecondaryLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: _color.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.poppins(color: _color.textSecondaryLight);
        }),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _color.containerLight,
        selectedItemColor: _color.primary,
        unselectedItemColor: _color.textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: _color.primary,
      scaffoldBackgroundColor: _color.backgroundDark,

      appBarTheme: AppBarTheme(
        backgroundColor: _color.backgroundDark,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: _color.textPrimaryDark),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _color.textPrimaryDark,
        ),
      ),

      cardTheme: CardThemeData(
        color: _color.containerDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _color.containerDark,
        hintStyle: GoogleFonts.poppins(color: _color.textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),

      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        titleLarge: TextStyle(
          color: _color.textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        bodyMedium: TextStyle(color: _color.textPrimaryDark),
        bodySmall: TextStyle(color: _color.textSecondaryDark),
      ),

      colorScheme: ColorScheme.dark(
        primary: _color.primary,
        surface: _color.containerDark,
        error: _color.danger,
        onSurface: _color.textPrimaryDark,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _color.containerDark,
        indicatorColor: _color.primary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: _color.primary);
          }
          return IconThemeData(color: _color.textSecondaryDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              color: _color.primary,
              fontWeight: FontWeight.w600,
            );
          }
          return GoogleFonts.poppins(color: _color.textSecondaryDark);
        }),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _color.containerDark,
        selectedItemColor: _color.primary,
        unselectedItemColor: _color.textSecondaryDark,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
