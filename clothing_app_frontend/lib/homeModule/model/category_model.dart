import 'dart:convert';
import 'dart:typed_data';

class Category {
  final String id;
  final String name;
  final String image; // base64 string
 

  Category({
    required this.id,
    required this.name,
    required this.image,
    
  });

  /// Factory to safely create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
    
    );
  }

  /// Optional helper to replace existing jsonToCategory
  static Category jsonToCategory(Map<String, dynamic> json) =>
      Category.fromJson(json);

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'image': image,
  };

  /// Returns `Uint8List` from base64-encoded image string
  Uint8List? get decodedImage {
    if (image.isEmpty) return null;
    final base64Part = image.contains(',') ? image.split(',').last : image;
    try {
      return base64Decode(base64Part);
    } catch (_) {
      return null;
    }
  }

  /// Utility to safely parse ISO date strings
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.tryParse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
