import 'package:flutter/foundation.dart';

class PointsService {
  static final ValueNotifier<int> totalPoints = ValueNotifier<int>(1218);
  static final ValueNotifier<int> todayPoints = ValueNotifier<int>(20);

  static void addRidePoints(double distanceKm) {
    final pts = (distanceKm * 5).round();
    if (pts <= 0) return;
    totalPoints.value += pts;
    todayPoints.value += pts;
  }

  static void addReferralPoints() {
    totalPoints.value += 100;
    todayPoints.value += 100;
  }
}
