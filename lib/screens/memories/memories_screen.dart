import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ridermate_app/services/memories_service.dart';

class MemoriesScreen extends StatefulWidget {
  const MemoriesScreen({super.key});

  @override
  State<MemoriesScreen> createState() => _MemoriesScreenState();
}

class _MemoriesScreenState extends State<MemoriesScreen> {
  bool _isSaving = false;

  Future<void> _addMemory() async {
    final noteController = TextEditingController();
    String selectedPrivacy = 'private';
    final imageUrlController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A1D),
          title: const Text('Add Memory'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: noteController,
                  decoration:
                      const InputDecoration(hintText: 'What do you want to remember?'),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Privacy'),
                ),
                const SizedBox(height: 6),
                DropdownButton<String>(
                  value: selectedPrivacy,
                  dropdownColor: const Color(0xFF1A1A1D),
                  items: const [
                    DropdownMenuItem(
                      value: 'private',
                      child: Text('Private'),
                    ),
                    DropdownMenuItem(
                      value: 'friends',
                      child: Text('Friends'),
                    ),
                    DropdownMenuItem(
                      value: 'public',
                      child: Text('Public'),
                    ),
                  ],
                  onChanged: (v) {
                    if (v == null) return;
                    selectedPrivacy = v;
                    (ctx as Element).markNeedsBuild();
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    hintText: 'Optional image URL (for now)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != true) return;
    final note = noteController.text.trim();
    if (note.isEmpty) return;

    setState(() {
      _isSaving = true;
    });

    double? lat;
    double? lon;

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        var perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm == LocationPermission.always ||
            perm == LocationPermission.whileInUse) {
          final pos = await Geolocator.getCurrentPosition();
          lat = pos.latitude;
          lon = pos.longitude;
        }
      }
    } catch (_) {
      // ignore
    }

    MemoriesService.addMemory(
      MemoryEntry(
        note: note,
        timestamp: DateTime.now(),
        privacy: selectedPrivacy,
        lat: lat,
        lon: lon,
        imageUrl: imageUrlController.text.trim().isEmpty
            ? null
            : imageUrlController.text.trim(),
      ),
    );

    setState(() {
      _isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final memories = MemoriesService.memories;

    return Scaffold(
      appBar: AppBar(title: const Text('Memories')),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : memories.isEmpty
              ? const Center(
                  child: Text(
                    'No memories yet.\nTap + to add one.',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: memories.length,
                  itemBuilder: (context, index) {
                    final m = memories[index];
                    String locationText = 'Location: unknown';
                    if (m.lat != null && m.lon != null) {
                      locationText =
                          'Location: ${m.lat!.toStringAsFixed(4)}, ${m.lon!.toStringAsFixed(4)}';
                    }
                    String privacyLabel =
                        'Privacy: ${m.privacy[0].toUpperCase()}${m.privacy.substring(1)}';

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
                          if (m.imageUrl != null && m.imageUrl!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Image.network(
                                  m.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.black26,
                                    child: const Center(
                                      child: Text('Image failed to load'),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Text(
                            m.note,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            locationText,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            privacyLabel,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.timestamp.toString(),
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemory,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}
