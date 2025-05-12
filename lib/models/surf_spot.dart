// lib/models/surf_spot.dart

class SurfSpot {
  final String id;
  final String destination;
  final String address;
  final int difficultyLevel;
  final DateTime peakSeasonStart;
  final DateTime peakSeasonEnd;
  final String? photoUrl;

  SurfSpot({
    required this.id,
    required this.destination,
    required this.address,
    required this.difficultyLevel,
    required this.peakSeasonStart,
    required this.peakSeasonEnd,
    this.photoUrl,
  });

  factory SurfSpot.fromJson(Map<String, dynamic> json) {
    final fields = json['fields'] as Map<String, dynamic>? ?? {};

    // extract the first photo URL if present
    String? photo;
    final photos = fields['Photos'] as List<dynamic>?;
    if (photos != null && photos.isNotEmpty) {
      final first = photos[0] as Map<String, dynamic>;
      photo = first['url'] as String?;
    }
    return SurfSpot(
      id: json['id'] as String,
      destination: fields['Destination'] as String? ?? 'Unknown',
      address: fields['Address'] as String? ?? '',
      difficultyLevel: (fields['Difficulty Level'] as num?)?.toInt() ?? 0,
      peakSeasonStart: DateTime.parse(
        fields['Peak Surf Season Begins'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      peakSeasonEnd: DateTime.parse(
        fields['Peak Surf Season Ends'] as String? ??
            DateTime.now().toIso8601String(),
      ),
      photoUrl: photo,
    );
  }
}
