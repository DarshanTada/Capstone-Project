import 'package:clothing_app_frontend/homeModule/model/subCategory_model.dart';

class BodyTypeEntry {
  final String id;
  final String name;
  final List<SubCategory> subcategories;

  BodyTypeEntry({
    required this.id,
    required this.name,
    required this.subcategories,
  });

  static BodyTypeEntry jsonToBodyType(Map<String, dynamic> json) {
    final subcategoryList = (json['subcategory'] as List?) ?? [];

    final subcategories = subcategoryList.map<SubCategory>((e) {
      if (e is Map<String, dynamic>) {
        return SubCategory.jsonToSubCategory(e);
      } else {
        return SubCategory(id: e.toString(), name: '', image: '');
      }
    }).toList();

    return BodyTypeEntry(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      subcategories: subcategories,
    );
  }

 Map<String, dynamic> toJson() {
  return {
    '_id': id,
    'name': name,
    'subcategory': subcategories
        .where((s) => s != null) // filter out nulls
        .map((s) => s.toJson())
        .toList(),
  };
}

}
