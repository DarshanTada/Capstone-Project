class SubCategory {
  final String id;
  final String name;
  final String image; // base64 from backend, if available

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  static SubCategory jsonToSubCategory(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }

  /// Add this method for serialization
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
    };
  }
}
