import 'package:duha_app/features/groups/presentation/screens/social_screen.dart';
import 'package:duha_app/features/notifications/data/datasources/notification_service.dart';
import 'package:duha_app/features/profile/presentation/screens/profile_screen.dart';
import 'package:duha_app/features/projects/presentation/screens/history_screen.dart';
import 'package:duha_app/features/tasks/presentation/screens/list_view_screen.dart';
import 'package:duha_app/features/home/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.initialize();
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const CustomListView(),
    const SocialScreen(),
    const HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7C3AED),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Social'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
