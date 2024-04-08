import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/dashboard.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:my_app/pages/sidebar.dart';
import 'package:my_app/utils/constants.dart';

class NavigatorBarPage extends StatefulWidget {
  const NavigatorBarPage({super.key});

  @override
  State<NavigatorBarPage> createState() => _NavigatorBarPageState();
}

class _NavigatorBarPageState extends State<NavigatorBarPage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: primaryFontColor,
            fontSize: 26,
          ),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: secondaryColor,
        buttonBackgroundColor: primaryColor,
        items: [
          Icon(
            Icons.home,
            size: 30.0,
            color: _selectedIndex == 0 ? primaryFontColor : primaryColor,
          ),
          Icon(
            Icons.person,
            size: 30.0,
            color: _selectedIndex == 1 ? primaryFontColor : primaryColor,
          ),
        ],
        index: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
