import 'package:flutter/material.dart';
import 'package:ridermate_app/models/chat_message.dart';
import 'package:ridermate_app/services/ai_coach_service.dart';
import 'package:ridermate_app/services/ride_history_service.dart';

class CoachScreen extends StatefulWidget {
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  late CoachStats _stats;
  bool _loadingSummary = false;
  String? _summaryText;

  bool _loadingAnswer = false;
  final TextEditingController _questionController = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _stats = AICoachService.computeStats();
    _generateInitialSummary();
  }

  Future<void> _generateInitialSummary() async {
    setState(() {
      _loadingSummary = true;
    });
    try {
      final answer = await AICoachService.askCoach(
        stats: _stats,
        userQuestion: null,
      );
      setState(() {
        _summaryText = answer;
      });
    } catch (e) {
      setState(() {
        _summaryText = 'Failed to get AI summary: $e';
      });
    } finally {
      setState(() {
        _loadingSummary = false;
      });
    }
  }

  Future<void> _askQuestion() async {
    final text = _questionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(sender: 'user', text: text));
      _questionController.clear();
      _loadingAnswer = true;
    });

    try {
      final answer = await AICoachService.askCoach(
        stats: _stats,
        userQuestion: text,
      );
      setState(() {
        _messages.add(ChatMessage(sender: 'ai', text: answer));
      });
    } catch (e) {
      setState(() {
        _messages
            .add(ChatMessage(sender: 'ai', text: 'Error from AI Coach: $e'));
      });
    } finally {
      setState(() {
        _loadingAnswer = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rides = RideHistoryService.rides;
    final lastRide = rides.isNotEmpty ? rides.first : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Ride Coach'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'This week',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 4),
                Text('Rides: ${_stats.totalRidesWeek}'),
                Text(
                    'Distance: ${_stats.totalKmWeek.toStringAsFixed(2)} km • Points: ${_stats.totalPointsWeek}'),
                Text('Overspeed events: ${_stats.totalOverspeedsWeek}'),
                const SizedBox(height: 8),
                Text(
                  'Safety score: ${_stats.safetyScore} / 100',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _stats.safetyScore >= 80
                        ? Colors.greenAccent
                        : _stats.safetyScore >= 50
                            ? Colors.orangeAccent
                            : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  'AI summary & recommendations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (_loadingSummary)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: LinearProgressIndicator(),
                  )
                else
                  Text(
                    _summaryText ??
                        'Tap refresh to get AI-generated ride summary.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _generateInitialSummary,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh AI Summary'),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  'Last ride snapshot',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (lastRide == null)
                  const Text('No recent ride to analyse.')
                else ...[
                  Text(
                    '${_stats.lastRideKm.toStringAsFixed(2)} km in ${_stats.lastRideMinutes} min',
                  ),
                  Text(
                    'Avg speed: ${_stats.lastRideAvgSpeed.toStringAsFixed(1)} km/h',
                  ),
                  Text(
                    'Overspeed events: ${_stats.lastRideOverspeeds}',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                  Text(
                    'Started: ${lastRide.startTime}',
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],

                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 8),

                const Text(
                  'Ask your AI coach',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Example: "Is it safe to ride at night in rain?", '
                  '"How often should I take breaks for a 200 km ride?", '
                  '"Suggest petrol bunks and food on my route."',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 10),

                // Chat messages
                if (_messages.isEmpty)
                  const Text(
                    'No questions yet. Ask anything about riding safer!',
                    style: TextStyle(color: Colors.white54),
                  )
                else
                  ..._messages.map((m) {
                    final isUser = m.sender == 'user';
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        constraints: const BoxConstraints(maxWidth: 260),
                        decoration: BoxDecoration(
                          color: isUser
                              ? Colors.orange.withOpacity(0.8)
                              : const Color(0xFF1F1F22),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          m.text,
                          style: TextStyle(
                            color: isUser ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Question input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
            decoration: const BoxDecoration(
              color: Color(0xFF151518),
              border: Border(
                top: BorderSide(color: Colors.white12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      hintText: 'Ask AI coach anything...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                _loadingAnswer
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: _askQuestion,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
