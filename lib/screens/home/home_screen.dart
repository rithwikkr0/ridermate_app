import 'package:flutter/material.dart';
import 'package:ridermate_app/services/points_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Widget tile(Widget child) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1D),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white12),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          Text(
            'Home',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Ride safer with RiderMate',
            style: TextStyle(color: Colors.white54),
          ),

          const SizedBox(height: 20),

          tile(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Start Ride',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    // You can later trigger auto switch to Ride tab.
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text('Start tracking'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: tile(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Last ride'),
                      SizedBox(height: 6),
                      Text(
                        '— km',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Open History',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: tile(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Safety Score'),
                      const SizedBox(height: 6),
                      const Text(
                        '87 / 100',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Good',
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          tile(
            SizedBox(
              height: 120,
              child: Center(
                child: Text(
                  'Ride stats graph coming soon...',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/leaderboard');
            },
            child: tile(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '#12',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          tile(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Points',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ValueListenableBuilder<int>(
                  valueListenable: PointsService.totalPoints,
                  builder: (context, total, _) {
                    return Text(
                      'Total: $total pts',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                ValueListenableBuilder<int>(
                  valueListenable: PointsService.todayPoints,
                  builder: (context, today, _) {
                    return Text(
                      'Today: +$today pts',
                      style: const TextStyle(color: Colors.greenAccent),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/referral');
            },
            child: tile(
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Invite Friends',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: const [
                      Text(
                        '+100 pts',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.share),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
