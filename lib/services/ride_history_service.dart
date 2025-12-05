class RideEntry {
  final DateTime startTime;
  final DateTime endTime;
  final double distanceKm;
  final int pointsEarned;
  final int overspeedEvents;

  RideEntry({
    required this.startTime,
    required this.endTime,
    required this.distanceKm,
    required this.pointsEarned,
    required this.overspeedEvents,
  });
}

class RideHistoryService {
  static final List<RideEntry> _rides = [];

  static List<RideEntry> get rides => List.unmodifiable(_rides);

  static void addRide(RideEntry ride) {
    _rides.insert(0, ride);
  }
}
