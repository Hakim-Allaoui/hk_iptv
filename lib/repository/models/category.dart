class CategoryModel {
  final String? categoryId;
  final String? categoryName;
  final int? parentId;

  CategoryModel({
    this.categoryId,
    this.categoryName,
    this.parentId,
  });

  CategoryModel.fromJson(Map<String, dynamic> json)
      : categoryId = json['category_id'] as String?,
        categoryName = json['category_name'] as String?,
        parentId = json['parent_id'] as int?;

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'parent_id': parentId,
      };
}
