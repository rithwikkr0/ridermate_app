import 'package:flutter/material.dart';
import 'package:ridermate_app/main.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void _continue(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.motorcycle, size: 72, color: Colors.orange),
              const SizedBox(height: 16),
              const Text(
                'RiderMate',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ride safer with an AI coach',
                style: TextStyle(color: Colors.white60),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _continue(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.account_circle),
                label: const Text('Continue with Google (mock)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
