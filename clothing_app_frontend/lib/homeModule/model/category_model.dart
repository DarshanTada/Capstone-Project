import 'dart:convert';
import 'dart:typed_data';
import 'bodytype_model.dart';

class Category {
  final String id;
  String name;
  String image; // base64 string
  String gender;
  List<BodyTypeEntry> bodyTypes;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.gender,
    required this.bodyTypes,
    this.createdAt,
    this.updatedAt,
  });

  static Category jsonToCategory(Map<String, dynamic> category) {
    return Category(
      id: category['_id']?.toString() ?? '',
      name: category['name'] ?? '',
      image: category['image'] ?? '',
      gender: category['gender'] ?? '',
      bodyTypes: (category['body_type'] as List? ?? [])
          .map((bt) => BodyTypeEntry.jsonToBodyType(
              Map<String, dynamic>.from(bt)))
          .toList(),
      createdAt: category['createdAt'] != null
          ? DateTime.tryParse(category['createdAt'])
          : null,
      updatedAt: category['updatedAt'] != null
          ? DateTime.tryParse(category['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'image': image,
        'gender': gender,
        'body_type': bodyTypes.map((b) => b.toJson()).toList(),
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };
}

/// Helper to decode base64 image into Uint8List
Uint8List? decodeCategoryImage(String image) {
  if (image.isEmpty) return null;
  final base64Part =
      image.contains(',') ? image.split(',').last : image; // strip prefix
  try {
    return base64Decode(base64Part);
  } catch (_) {
    return null;
  }
}
