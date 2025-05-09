// lib/models/surf_spot.dart

class SurfSpot {
  final String id;
  final String name;
  final String location;

  SurfSpot({required this.id, required this.name, required this.location});

  factory SurfSpot.fromJson(Map<String, dynamic> json) {
    return SurfSpot(
      id: json['id'],
      name: json['name'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
    };
  }
}