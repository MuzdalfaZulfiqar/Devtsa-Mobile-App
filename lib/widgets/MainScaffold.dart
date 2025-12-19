import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_providers.dart';
import '../screens/dashboard/dashboard_screen.dart';
import './profile_overview.dart';
import '../screens/community/community_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Get token from AuthProvider
    final authProvider = context.watch<AuthProvider>();
    final token = authProvider.token ?? '';

    // Screens list must now be dynamic
    final List<Widget> screens = [
      const DashboardScreen(),
      ProfileOverview(token: token), 
      const CommunityScreen(),
    ];

    final List<String> titles = ["Dashboard", "Profile", "Resume", "Community"];

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          titles[_currentIndex],
          style: theme.appBarTheme.titleTextStyle,
        ),
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Community',
          ),
        ],
      ),
    );
  }
}
