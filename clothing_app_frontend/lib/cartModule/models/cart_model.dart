class CartModel {
  final String? id;
  final String user;
  final List<CartItem> items;
  final double subTotalAmount;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartModel({
    this.id,
    required this.user,
    required this.items,
    required this.subTotalAmount,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['_id']?.toString(),
      user: json['user']?.toString() ?? '',
      items:
          (json['items'] as List<dynamic>?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      subTotalAmount: (json['subTotalAmount'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'items': items.map((item) => item.toJson()).toList(),
      'subTotalAmount': subTotalAmount,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CartModel copyWith({
    String? id,
    String? user,
    List<CartItem>? items,
    double? subTotalAmount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      user: user ?? this.user,
      items: items ?? this.items,
      subTotalAmount: subTotalAmount ?? this.subTotalAmount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class CartItem {
  final String? id;
  final ProductInfo? product;
  final String variantId;
  final String size;
  final int quantity;
  final double price;
  final ProductVariant? variant;
  final String? image; // Changed from ProductImage? to String?
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CartItem({
    this.id,
    this.product,
    required this.variantId,
    required this.size,
    required this.quantity,
    required this.price,
    this.variant,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id']?.toString(),
      product: json['product'] != null
          ? ProductInfo.fromJson(json['product'])
          : null,
      variantId: json['variantId']?.toString() ?? '',
      size: json['size']?.toString() ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      variant: json['variant'] != null
          ? ProductVariant.fromJson(json['variant'])
          : null,
      image: json['image']?.toString(), // Handle image as string
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product': product?.toJson(),
      'variantId': variantId,
      'size': size,
      'quantity': quantity,
      'price': price,
      'variant': variant?.toJson(),
      'image': image, // Store image as string
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  CartItem copyWith({
    String? id,
    ProductInfo? product,
    String? variantId,
    String? size,
    int? quantity,
    double? price,
    ProductVariant? variant,
    String? image, // Changed from ProductImage? to String?
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      variantId: variantId ?? this.variantId,
      size: size ?? this.size,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      variant: variant ?? this.variant,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class ProductInfo {
  final String? id;
  final String? name;
  final String? description;

  ProductInfo({this.id, this.name, this.description});

  factory ProductInfo.fromJson(Map<String, dynamic> json) {
    return ProductInfo(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      description: json['description']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'description': description};
  }
}

class ProductVariant {
  final String? id;
  final String? productObjectId;
  final String? size;
  final String? availableStatus;
  final String? color;
  final String? sku;
  final int? stockQty;
  final double? price;
  final double? discountPrice;
  final bool? isFeatured;
  final bool? isNewArrival;
  final bool? isOnTrend;

  ProductVariant({
    this.id,
    this.productObjectId,
    this.size,
    this.availableStatus,
    this.color,
    this.sku,
    this.stockQty,
    this.price,
    this.discountPrice,
    this.isFeatured,
    this.isNewArrival,
    this.isOnTrend,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    return ProductVariant(
      id: json['_id']?.toString(),
      productObjectId: json['productObjectId']?.toString(),
      size: json['size']?.toString(),
      availableStatus: json['available_status']?.toString(),
      color: json['color']?.toString(),
      sku: json['sku']?.toString(),
      stockQty: (json['stock_qty'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toDouble(),
      discountPrice: (json['discount_price'] as num?)?.toDouble(),
      isFeatured: json['is_featured'] as bool?,
      isNewArrival: json['is_new_arrival'] as bool?,
      isOnTrend: json['is_on_trend'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'productObjectId': productObjectId,
      'size': size,
      'available_status': availableStatus,
      'color': color,
      'sku': sku,
      'stock_qty': stockQty,
      'price': price,
      'discount_price': discountPrice,
      'is_featured': isFeatured,
      'is_new_arrival': isNewArrival,
      'is_on_trend': isOnTrend,
    };
  }
}

class ProductImage {
  final String? id;
  final String? image;
  final bool? isPrimary;
  final int? sortOrder;

  ProductImage({this.id, this.image, this.isPrimary, this.sortOrder});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['_id']?.toString(),
      image: json['image']?.toString(),
      isPrimary: json['is_primary'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'image': image,
      'is_primary': isPrimary,
      'sort_order': sortOrder,
    };
  }
}
