class MemoryEntry {
  final String note;
  final double? lat;
  final double? lon;
  final DateTime timestamp;
  final String privacy; // 'public' | 'friends' | 'private'
  final String? imageUrl; // optional, can be network URL

  MemoryEntry({
    required this.note,
    required this.timestamp,
    required this.privacy,
    this.lat,
    this.lon,
    this.imageUrl,
  });
}

class MemoriesService {
  static final List<MemoryEntry> _memories = [];

  static List<MemoryEntry> get memories => List.unmodifiable(_memories);

  static void addMemory(MemoryEntry m) {
    _memories.insert(0, m);
  }
}
