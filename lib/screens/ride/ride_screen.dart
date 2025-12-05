import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridermate_app/services/points_service.dart';
import 'package:ridermate_app/services/ride_history_service.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  bool isRiding = false;
  double distanceKm = 0.0;
  double speedKmh = 0.0;
  int overspeedEvents = 0;

  Position? _lastPosition;
  DateTime? _startTime;
  StreamSubscription<Position>? _positionSub;

  static const double speedLimitKmh = 60.0;

  Future<bool> _ensureLocationPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return false;
    }

    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return false;
    }
    return true;
  }

  void _startRide() async {
    if (isRiding) return;
    if (!await _ensureLocationPermission()) return;

    setState(() {
      isRiding = true;
      distanceKm = 0.0;
      speedKmh = 0.0;
      overspeedEvents = 0;
      _startTime = DateTime.now();
      _lastPosition = null;
    });

    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 0,
      ),
    ).listen((pos) {
      if (!mounted || !isRiding) return;

      final newSpeedKmh = pos.speed * 3.6;
      double extraDistKm = 0.0;

      if (_lastPosition != null) {
        extraDistKm = Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              pos.latitude,
              pos.longitude,
            ) /
            1000.0;
      }

      if (newSpeedKmh > speedLimitKmh) {
        overspeedEvents++;
      }

      setState(() {
        speedKmh = newSpeedKmh;
        distanceKm += extraDistKm;
        _lastPosition = pos;
      });
    });
  }

  void _stopRide() {
    if (!isRiding) return;

    _positionSub?.cancel();
    _positionSub = null;

    final endTime = DateTime.now();
    final start = _startTime ?? endTime;
    setState(() {
      isRiding = false;
    });

    final pts = (distanceKm * 5).round();
    PointsService.addRidePoints(distanceKm);

    RideHistoryService.addRide(
      RideEntry(
        startTime: start,
        endTime: endTime,
        distanceKm: distanceKm,
        pointsEarned: pts,
        overspeedEvents: overspeedEvents,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ride ended: ${distanceKm.toStringAsFixed(2)} km  •  +$pts pts',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Map placeholder – you can later replace with GoogleMap widget
        Container(color: Colors.black87),

        Positioned(
          top: 40,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Ride Session'),
                Icon(Icons.more_horiz),
              ],
            ),
          ),
        ),

        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.65),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.white12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Speed: ${speedKmh.toStringAsFixed(1)} km/h'),
                    Text('Distance: ${distanceKm.toStringAsFixed(2)} km'),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Overspeeds: $overspeedEvents (limit $speedLimitKmh km/h)',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/history');
                        },
                        child: const Text('Ride Journal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: isRiding ? _stopRide : _startRide,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isRiding ? Colors.redAccent : Colors.orange,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: Text(isRiding ? 'Stop' : 'Start'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
