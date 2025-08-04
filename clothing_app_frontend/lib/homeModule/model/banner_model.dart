class Banner {
  String? id;
  String? title;
  String? description;
  String? image;
  String? type;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  Banner({
    this.id,
    this.title,
    this.description,
    this.image,
    this.type,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  static Banner jsonToBanner(Map<String, dynamic> json) {
    return Banner(
      id: json['_id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      type: json['type']?.toString(),
      isActive: json['is_active'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'image': image,
      'type': type,
      'is_active': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Banner{id: $id, title: $title, type: $type, isActive: $isActive}';
  }
}
