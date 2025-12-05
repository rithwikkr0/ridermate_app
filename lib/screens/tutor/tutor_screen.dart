import 'package:flutter/material.dart';

class TutorScreen extends StatefulWidget {
  const TutorScreen({super.key});

  @override
  State<TutorScreen> createState() => _TutorScreenState();
}

class _TutorScreenState extends State<TutorScreen> {
  String _currentTopic = "Tap a topic to see safety tips.";

  final Map<String, String> _tips = const {
    "Night riding":
        "• Use a clear visor or clean spectacles.\n• Reduce speed and increase following distance.\n• Wear reflective gear or bright clothing.\n• Watch for unlit vehicles, animals and potholes.\n• Avoid staring at oncoming headlights.",
    "Rainy conditions":
        "• Avoid sudden braking; use both brakes gently.\n• Keep a bigger distance from other vehicles.\n• Stay away from painted lines and manhole covers (they are slippery).\n• Slow down before turns.\n• Dry your brakes by gently applying them after puddles.",
    "Highway":
        "• Maintain a stable lane and avoid sudden lane changes.\n• Use indicators early.\n• Do not ride in blind spots of large vehicles.\n• Take breaks to avoid fatigue.\n• Keep extra margin for braking at high speeds.",
    "City traffic":
        "• Do not weave aggressively between vehicles.\n• Watch for pedestrians and sudden door openings.\n• Keep both hands on handlebar; avoid phone usage.\n• Anticipate buses and autos stopping suddenly.",
    "Bad roads":
        "• Stand slightly on the pegs over big bumps.\n• Reduce speed when you cannot see the road clearly.\n• Avoid puddles when you cannot judge depth.\n• Keep a loose but firm grip on the handlebar.",
  };

  @override
  Widget build(BuildContext context) {
    final buttons = _tips.keys.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Safety Tutor")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: buttons
                  .map(
                    (topic) => OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentTopic = _tips[topic]!;
                        });
                      },
                      child: Text(topic),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1D),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white12),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _currentTopic,
                    style: const TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
