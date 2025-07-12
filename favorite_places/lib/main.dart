import 'package:favorite_places/screens/places.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

// Professional Color Schemes
const primaryColor = Color(0xFF8B5CF6); // Purple
const secondaryColor = Color(0xFFA855F7); // Lighter purple
const accentColor = Color(0xFFEC4899); // Pink accent

final darkColorScheme = ColorScheme.dark(
  primary: primaryColor,
  secondary: secondaryColor,
  tertiary: accentColor,
  surface: const Color(0xFF1A1A1A),
  background: const Color(0xFF0F0F0F),
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.white,
  onBackground: Colors.white,
  brightness: Brightness.dark,
);

final darkTheme = ThemeData.dark().copyWith(
  colorScheme: darkColorScheme,
  scaffoldBackgroundColor: darkColorScheme.background,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorScheme.surface,
    elevation: 0,
    titleTextStyle: GoogleFonts.ubuntuCondensed(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
  ),
  cardTheme: CardThemeData(
    color: darkColorScheme.surface,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
    titleSmall: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w800,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w900,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: GoogleFonts.ubuntuCondensed(
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white.withOpacity(0.1),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white70),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF1A1A1A),
  ),
);



void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Favorite Places',
      theme: darkTheme,
      home: const PlacesScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
