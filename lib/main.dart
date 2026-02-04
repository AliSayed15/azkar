import 'package:flutter/material.dart';
  import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/azkar_categories_screen.dart';


void main() {
  runApp(const AzkarApp());
}

// 🎨 Colors
const Color primaryGreen = Color(0xFF1F6E43);
const Color goldAccent = Color(0xFFC9A24D);
const Color backgroundColor = Color(0xFFF8F9F6);
const Color textPrimary = Color(0xFF2E2E2E);
const Color textSecondary = Color(0xFF6B7280);

class AzkarApp extends StatelessWidget {
  const AzkarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🌍 Arabic + RTL
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],

      // ✅ THIS IS THE IMPORTANT PART
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: backgroundColor,

        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: goldAccent,
          background: backgroundColor,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: primaryGreen,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: primaryGreen),
        ),
      ),

home: const AzkarCategoriesScreen(),    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الأذكار'),
      ),
      body: const Center(
        child: Text(
          'واجهة مؤقتة\nسنبدأ التصميم الحقيقي الآن',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}