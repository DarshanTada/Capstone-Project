class SubCategory {
  final String id;
  final String name;
  final String image; // base64 from backend, if available
  final String gender; 
  final String bodyType; 

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
    required this.gender,
    required this.bodyType,
  });

  static SubCategory jsonToSubCategory(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id']?.toString() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      gender: json['gender'] ?? '',
      bodyType: json['bodyType'] ?? '',
    );
  }

  /// Add this method for serialization
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image,
      'gender': gender,
      'bodyType': bodyType,
    };
  }
}
