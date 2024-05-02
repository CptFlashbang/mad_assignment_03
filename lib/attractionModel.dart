class AttractionModel {
  final String id;
  final String name;
  final bool saved;
  AttractionModel({
    required this.id,
    required this.name,
    required this.saved
  });
  factory AttractionModel.fromJson(Map<String, dynamic> data) => AttractionModel(
    id: data['id'],
    name: data['name'],
    saved: data['saved'],
  );
  Map<String, dynamic> toMap() => {
  'id': id,
  'name': name,
  'saved': saved,
};
}