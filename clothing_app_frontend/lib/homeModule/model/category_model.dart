class Category {
  final String id;
  String name;
  String image; // base64 string from backend

  Category({
    required this.id,
    required this.name,
    required this.image,
  });

  static Category jsonToCategory(Map<String, dynamic> category) => Category(
        id: category['_id'] ?? '',
        name: category['name'] ?? '',
        image: category['image'] ?? '', // base64 image string
      );
}
