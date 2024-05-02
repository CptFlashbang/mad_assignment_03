class AttractionModel {
  final String id;
  final String title;
  final bool saved;
  AttractionModel({
    required this.id,
    required this.title,
    required this.saved
  });
  factory AttractionModel.fromJson(Map<String, dynamic> data) => AttractionModel(
    id: data['id'],
    title: data['title'],
    saved: data['saved'],
  );
  Map<String, dynamic> toMap() => {
  'id': id,
  'title': title,
  'saved': saved,
};
}