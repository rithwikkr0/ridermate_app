import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummy = [
      {'name': 'Rider 1', 'points': 1820},
      {'name': 'Rider 2', 'points': 1700},
      {'name': 'Rider 3', 'points': 1660},
      {'name': 'You', 'points': 1218},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: dummy.length,
        itemBuilder: (context, index) {
          final d = dummy[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1D),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${index + 1}. ${d['name']}',
                    style: const TextStyle(fontSize: 18)),
                Text('${d['points']} pts',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          );
        },
      ),
    );
  }
}
