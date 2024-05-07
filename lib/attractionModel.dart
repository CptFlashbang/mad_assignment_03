class AttractionModel {
  final String id;
  final String name;
  final String description;  // Added to support descriptions
  final bool saved;
  final double latitude;
  final double longitude;

  AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.saved,
    required this.latitude,
    required this.longitude,
  });

  factory AttractionModel.fromJson(Map<String, dynamic> data) => AttractionModel(
    id: data['attractionID'],
    name: data['attractionTitle'],
    description: data['attractionDescription'],
    saved: false,
    latitude: data['latitude'].toDouble(),
    longitude: data['longitude'].toDouble(),
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description,
    'saved': saved,
    'latitude': latitude,
    'longitude': longitude,
  };
}
