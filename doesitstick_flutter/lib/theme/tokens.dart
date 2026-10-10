import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Pixel's "Playful Modern" tokens. Brand colors fill shapes; text on a tint
/// always uses the dark "t" shade. No red, ever.
class C {
  static const cream = Color(0xFFFFF8EE);
  static const paper = Color(0xFFFFFFFF);
  static const ink = Color(0xFF2A2350);
  static const ink2 = Color(0xFF6B6487);
  static const line = Color(0xFFEFE7DA);
  static const grape = Color(0xFF6C4CF5);
  static const grapeD = Color(0xFF4E33CF);
  static const grapeS = Color(0xFFF0EBFF);
  static const grapeT = Color(0xFF4A2FC4);
  static const sun = Color(0xFFFFC93C);
  static const sunS = Color(0xFFFFF4D1);
  static const sunT = Color(0xFF8A5A00);
  static const mint = Color(0xFF2DC98A);
  static const mintD = Color(0xFF1FA06C);
  static const mintS = Color(0xFFDDF7EC);
  static const mintT = Color(0xFF157A52);
  static const coral = Color(0xFFFF8A6B);
  static const coralS = Color(0xFFFFE9E2);
  static const coralT = Color(0xFFB5452A);
  static const sky = Color(0xFF4DB2FF);
  static const skyS = Color(0xFFE3F3FF);
  static const skyT = Color(0xFF1C6BA8);
}

const shadow = [
  BoxShadow(color: Color(0x0F4E33CF), blurRadius: 2, offset: Offset(0, 1)),
  BoxShadow(
    color: Color(0x474E33CF),
    blurRadius: 28,
    spreadRadius: -12,
    offset: Offset(0, 12),
  ),
];

ThemeData buildTheme() {
  final base = GoogleFonts.nunitoTextTheme().apply(
    bodyColor: C.ink,
    displayColor: C.ink,
  );
  TextStyle w(TextStyle? s, double size, FontWeight weight) =>
      s!.copyWith(fontSize: size, fontWeight: weight, height: 1.3);
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: C.cream,
    colorScheme: ColorScheme.fromSeed(
      seedColor: C.grape,
      primary: C.grape,
      surface: C.cream,
      error: C.coralT,
    ),
    textTheme: base.copyWith(
      displaySmall: w(base.displaySmall, 30, FontWeight.w600),
      headlineSmall: w(base.headlineSmall, 24, FontWeight.w600),
      titleLarge: w(base.titleLarge, 21, FontWeight.w600),
      titleMedium: w(base.titleMedium, 17, FontWeight.w600),
      bodyLarge: w(base.bodyLarge, 16, FontWeight.w400),
      bodyMedium: w(base.bodyMedium, 15, FontWeight.w400),
      bodySmall: w(base.bodySmall, 14, FontWeight.w400).copyWith(color: C.ink2),
      labelLarge: w(base.labelLarge, 17, FontWeight.w600),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: C.grape,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(56),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.nunito(
          fontSize: 17,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: C.grapeT,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: C.line, width: 2),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: C.paper,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: C.line, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: C.line, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(color: C.grape, width: 2),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: C.paper,
      indicatorColor: C.grapeS,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.nunito(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: C.ink,
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: C.ink,
    ),
  );
}
