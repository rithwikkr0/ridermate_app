import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ridermate_app/services/ride_history_service.dart';

class CoachStats {
  final double totalKmWeek;
  final int totalRidesWeek;
  final int totalOverspeedsWeek;
  final int totalPointsWeek;
  final double lastRideKm;
  final int lastRideMinutes;
  final int lastRideOverspeeds;
  final double lastRideAvgSpeed;
  final int safetyScore; // 0–100

  CoachStats({
    required this.totalKmWeek,
    required this.totalRidesWeek,
    required this.totalOverspeedsWeek,
    required this.totalPointsWeek,
    required this.lastRideKm,
    required this.lastRideMinutes,
    required this.lastRideOverspeeds,
    required this.lastRideAvgSpeed,
    required this.safetyScore,
  });
}

class AICoachService {
  /// TODO: change this to your deployed backend URL
  static const String _backendUrl =
      'https://symmetrical-parakeet-v655rvxj577ghw6pq-3000.app.github.dev/';

  /// Computes stats from the last 7 days of rides.
  static CoachStats computeStats() {
    final now = DateTime.now();
    final lastWeek = now.subtract(const Duration(days: 7));

    final rides = RideHistoryService.rides
        .where((r) => r.startTime.isAfter(lastWeek))
        .toList();

    double totalKm = 0;
    int totalPoints = 0;
    int totalOverspeeds = 0;

    for (final r in rides) {
      totalKm += r.distanceKm;
      totalPoints += r.pointsEarned;
      totalOverspeeds += r.overspeedEvents;
    }

    final lastRide = rides.isNotEmpty ? rides.first : null;
    double lastKm = 0;
    int lastMins = 0;
    int lastOvers = 0;
    double lastAvgSpeed = 0;

    if (lastRide != null) {
      lastKm = lastRide.distanceKm;
      final duration = lastRide.endTime.difference(lastRide.startTime);
      lastMins = duration.inMinutes;
      lastOvers = lastRide.overspeedEvents;
      if (lastMins > 0) {
        lastAvgSpeed = lastKm / (lastMins / 60.0);
      }
    }

    // Simple safety score: 100 - 3 points per overspeed this week
    int score = 100 - (totalOverspeeds * 3);
    if (score < 0) score = 0;

    return CoachStats(
      totalKmWeek: totalKm,
      totalRidesWeek: rides.length,
      totalOverspeedsWeek: totalOverspeeds,
      totalPointsWeek: totalPoints,
      lastRideKm: lastKm,
      lastRideMinutes: lastMins,
      lastRideOverspeeds: lastOvers,
      lastRideAvgSpeed: lastAvgSpeed.isNaN ? 0 : lastAvgSpeed,
      safetyScore: score,
    );
  }

  /// Calls your backend AI Coach endpoint with stats + optional user question.
  /// The backend will call OpenAI and return a text response.
  static Future<String> askCoach({
    required CoachStats stats,
    String? userQuestion,
    double? currentLat,
    double? currentLon,
  }) async {
    final body = {
      'stats': {
        'totalKmWeek': stats.totalKmWeek,
        'totalRidesWeek': stats.totalRidesWeek,
        'totalOverspeedsWeek': stats.totalOverspeedsWeek,
        'totalPointsWeek': stats.totalPointsWeek,
        'lastRideKm': stats.lastRideKm,
        'lastRideMinutes': stats.lastRideMinutes,
        'lastRideOverspeeds': stats.lastRideOverspeeds,
        'lastRideAvgSpeed': stats.lastRideAvgSpeed,
        'safetyScore': stats.safetyScore,
      },
      'question': userQuestion,
      'location': {
        'lat': currentLat,
        'lon': currentLon,
      },
    };

    final uri = Uri.parse(_backendUrl);
    final res = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (res.statusCode != 200) {
      throw Exception('AI Coach error: ${res.statusCode} ${res.body}');
    }

    final json = jsonDecode(res.body);
    // Expecting { "answer": "..." }
    return (json['answer'] as String?) ??
        'AI Coach could not generate a response.';
  }
}
