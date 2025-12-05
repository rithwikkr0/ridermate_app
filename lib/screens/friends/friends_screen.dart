import 'package:flutter/material.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyFriends = [
      {'name': 'Rider 1', 'status': 'Online'},
      {'name': 'Rider 2', 'status': 'Offline'},
      {'name': 'Rider 3', 'status': 'Riding'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Travel with Friends')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1D),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white12),
              ),
              child: const Text(
                'Create a group ride and share a link with trusted friends so they can watch your progress live.\n\nIn the future, this screen can connect to a backend for real-time location sharing.',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
              ),
              child: const Text('Start Group Ride (coming soon)'),
            ),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Friends',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: dummyFriends.length,
                itemBuilder: (context, index) {
                  final f = dummyFriends[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(f['name'] as String),
                    subtitle: Text(f['status'] as String),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
