class Product {
  final String id;
  final String name;
  final String description;
  final String fabricType;
  final String categoryId;
  final String subCategoryId;
  final String reviewObjectId;
  final String gender;
  final String bodyType;
  final List<String> seasonObjectIds;
  final List<String> festivalObjectIds;
  final List<String> careInstructionObjectIds;
  final String height;
  final String productType;
  final List<String> style;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.fabricType,
    required this.categoryId,
    required this.subCategoryId,
    required this.reviewObjectId,
    required this.gender,
    required this.bodyType,
    required this.seasonObjectIds,
    required this.festivalObjectIds,
    required this.careInstructionObjectIds,
    required this.height,
    required this.productType,
    required this.style,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      fabricType: json['fabric_type'] ?? '',
      categoryId: json['categoryId'] ?? json['category_id'] ?? '',
      subCategoryId: json['subCategoryId'] ?? json['subcategory_id'] ?? '',
      reviewObjectId: json['reviewObjectId']?.toString() ?? '',
      gender: json['gender'] ?? '',
      bodyType: json['bodyType'] ?? '',
      seasonObjectIds: (json['season_objectId'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      festivalObjectIds: (json['festival_objectId'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      careInstructionObjectIds:
          (json['care_instruction_objectId'] as List? ?? [])
              .map((e) => e.toString())
              .toList(),
      height: json['height'] ?? '',
      productType: json['productType'] ?? '',
      style: (json['style'] as List? ?? []).map((e) => e.toString()).toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
