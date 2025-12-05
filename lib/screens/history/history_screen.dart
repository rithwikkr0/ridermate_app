import 'package:flutter/material.dart';
import 'package:ridermate_app/services/ride_history_service.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final rides = RideHistoryService.rides;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride History')),
      body: rides.isEmpty
          ? const Center(child: Text('No rides recorded yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rides.length,
              itemBuilder: (context, index) {
                final r = rides[index];
                final duration = r.endTime.difference(r.startTime);
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${r.distanceKm.toStringAsFixed(2)} km  •  ${_formatDuration(duration)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Points: ${r.pointsEarned}',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Overspeed events: ${r.overspeedEvents}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        r.startTime.toString(),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
