import 'dart:convert';
import 'dart:typed_data';
import 'bodytype_model.dart';

class Category {
  final String id;
  final String name;
  final String image; // base64 string
  final String gender;
  final List<BodyTypeEntry> bodyTypes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.gender,
    required this.bodyTypes,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory to safely create a Category from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id']?.toString() ?? '',
      name: (json['name'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      gender: (json['gender'] ?? '').toString(),
      bodyTypes: (json['body_type'] as List? ?? [])
          .map(
            (bt) => BodyTypeEntry.jsonToBodyType(Map<String, dynamic>.from(bt)),
          )
          .toList(),
      createdAt: _parseDateTime(json['createdAt']),
      updatedAt: _parseDateTime(json['updatedAt']),
    );
  }

  /// Optional helper to replace existing jsonToCategory
  static Category jsonToCategory(Map<String, dynamic> json) =>
      Category.fromJson(json);

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'image': image,
    'gender': gender,
    'body_type': bodyTypes.map((b) => b.toJson()).toList(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
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
