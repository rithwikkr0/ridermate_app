import 'package:flutter/material.dart';
import 'package:ridermate_app/screens/home/home_screen.dart';
import 'package:ridermate_app/screens/ride/ride_screen.dart';
import 'package:ridermate_app/screens/coach/coach_screen.dart';
import 'package:ridermate_app/screens/friends/friends_screen.dart';
import 'package:ridermate_app/screens/memories/memories_screen.dart';
import 'package:ridermate_app/screens/history/history_screen.dart';
import 'package:ridermate_app/screens/leaderboard/leaderboard_screen.dart';
import 'package:ridermate_app/screens/referral/referral_screen.dart';
import 'package:ridermate_app/screens/login/login_screen.dart';

void main() {
  runApp(const RiderMateApp());
}

class RiderMateApp extends StatelessWidget {
  const RiderMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RiderMate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F10),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/': (_) => const MainNavigation(),
        '/history': (_) => const HistoryScreen(),
        '/leaderboard': (_) => const LeaderboardScreen(),
        '/referral': (_) => const ReferralScreen(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final _pages = const [
    HomeScreen(),
    RideScreen(),
    CoachScreen(),
    FriendsScreen(),
    MemoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        backgroundColor: const Color(0xFF161618),
        indicatorColor: Colors.orange.withOpacity(0.2),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Ride'),
          NavigationDestination(
              icon: Icon(Icons.assistant), label: 'AI Coach'),
          NavigationDestination(
              icon: Icon(Icons.group), label: 'Friends'),
          NavigationDestination(
              icon: Icon(Icons.photo_album), label: 'Memories'),
        ],
      ),
    );
  }
}
