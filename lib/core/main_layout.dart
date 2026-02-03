import 'package:flutter/material.dart';
import 'package:tasbeeh_app/features/azkar/azkarPage.dart';
import 'package:tasbeeh_app/features/statistics/statisticsPage.dart';
import 'package:tasbeeh_app/features/tasbeeh/presentation/presentationpage.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    TasbeehPage(),
    AzkarPage(),
    StatisticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.touch_app),
            label: 'Tasbeeh',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Azkar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
    );
  }
}