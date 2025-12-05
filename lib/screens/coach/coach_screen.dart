import 'package:flutter/material.dart';
import 'package:ridermate_app/services/ride_history_service.dart';

class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    final rides = RideHistoryService.rides
        .where((r) => r.startTime.isAfter(lastWeek))
        .toList();

    double totalKm = 0;
    int totalPoints = 0;
    int totalOverspeeds = 0;

    for (var r in rides) {
      totalKm += r.distanceKm;
      totalPoints += r.pointsEarned;
      totalOverspeeds += r.overspeedEvents;
    }

    String category;
    String summary;

    if (rides.isEmpty) {
      category = 'No data';
      summary =
          'No rides in the last 7 days. Start recording rides to get personalised coaching.';
    } else {
      final avgPointsPerRide = totalPoints / rides.length;
      if (avgPointsPerRide >= 80) {
        category = 'Safe';
        summary =
            'Your riding looks quite safe overall. Keep maintaining smooth speeds and avoiding sudden braking.';
      } else if (avgPointsPerRide >= 40) {
        category = 'Needs improvement';
        summary =
            'You are doing okay, but there is room to improve. Ride with a bit more margin and avoid last-second braking.';
      } else {
        category = 'Risky';
        summary =
            'Your rides appear risky. Try to slow down, avoid tailgating, and give yourself more time to react.';
      }
    }

    String restAdvice;
    if (totalKm >= 80) {
      restAdvice =
          'You have covered around ${totalKm.toStringAsFixed(1)} km this week. Make sure to take a 10–15 minute break every 60-90 minutes of riding.';
    } else {
      restAdvice =
          'Your weekly distance is moderate. Still, avoid riding more than 90 minutes at a stretch without a short break.';
    }

    String overspeedAdvice;
    if (totalOverspeeds == 0) {
      overspeedAdvice =
          'No overspeed events detected. Great job staying within safe limits.';
    } else if (totalOverspeeds <= 5) {
      overspeedAdvice =
          'You crossed the speed limit about $totalOverspeeds times. Try to anticipate speed limit changes and roll off the throttle early.';
    } else {
      overspeedAdvice =
          'High overspeed count ($totalOverspeeds). Slow down especially near intersections, schools, and pedestrian crossings. Avoid jumping signals or riding on the wrong side.';
    }

    final lastRide = rides.isNotEmpty ? rides.first : null;
    String lastRideSummary;
    if (lastRide == null) {
      lastRideSummary = 'No recent ride to analyse.';
    } else {
      final duration = lastRide.endTime.difference(lastRide.startTime);
      final mins = duration.inMinutes;
      final avgSpeed =
          lastRide.distanceKm == 0 ? 0 : lastRide.distanceKm / (mins / 60.0);
      lastRideSummary =
          'Last ride: ${lastRide.distanceKm.toStringAsFixed(2)} km in ${mins} min.\nEstimated average speed: ${avgSpeed.isNaN ? 0 : avgSpeed.toStringAsFixed(1)} km/h.\nOverspeed events: ${lastRide.overspeedEvents}.';
    }

    const petrolAdvice =
        'If your fuel is low, plan your refuelling stop early. Prefer well-lit, busy fuel stations and avoid last-moment panic refuelling.';
    const foodAdvice =
        'Avoid riding when very hungry or sleepy. For long rides, prefer light meals, water, and avoid heavy oily food that can make you drowsy. You can later integrate local restaurant and special food suggestions here using a maps API.';
    const routeAdvice =
        'Always follow lane discipline, avoid going on the wrong side, and never jump signals. Slow down in school zones, narrow streets, and busy markets even if there is no visible speed breaker.';

    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach (Rules-based)')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'This week',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text('Rides: ${rides.length}'),
          Text('Distance: ${totalKm.toStringAsFixed(2)} km'),
          Text('Points: $totalPoints'),
          Text('Overspeed events: $totalOverspeeds'),
          const SizedBox(height: 16),
          Text(
            'Category: $category',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ),
          ),
          const SizedBox(height: 12),
          Text(summary, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 24),
          const Text(
            'Last ride summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(lastRideSummary),
          const SizedBox(height: 24),
          const Text(
            'Rest advice',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(restAdvice),
          const SizedBox(height: 24),
          const Text(
            'Overspeed & signal safety',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(overspeedAdvice),
          const SizedBox(height: 8),
          Text(routeAdvice),
          const SizedBox(height: 24),
          const Text(
            'Fuel & food suggestions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(petrolAdvice),
          const SizedBox(height: 8),
          Text(foodAdvice),
        ],
      ),
    );
  }
}
