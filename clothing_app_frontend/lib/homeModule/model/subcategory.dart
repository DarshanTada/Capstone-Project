class SubCategory {
  final String id;
  final String name;
  final String image; // base64 or url string
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
