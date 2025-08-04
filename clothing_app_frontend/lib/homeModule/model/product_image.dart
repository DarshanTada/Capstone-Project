class ProductImage {
  final String id;
  final String productObjectId;
  final String variantObjectId;
  final String base64;
  final String contentType;
  final bool isPrimary;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductImage({
    required this.id,
    required this.productObjectId,
    required this.variantObjectId,
    required this.base64,
    required this.contentType,
    required this.isPrimary,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['_id']?.toString() ?? '',
      productObjectId: json['productObjectId']?.toString() ?? '',
      variantObjectId: json['variantObjectid']?.toString() ?? '',
      base64: json['image']?['base64']?.toString() ?? '',
      contentType: json['image']?['contentType']?.toString() ?? '',
      isPrimary: json['is_primary'] ?? false,
      sortOrder: json['sort_order'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'].toString())
          : null,
    );
  }
}
