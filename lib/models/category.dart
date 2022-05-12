class Category{
  final int categoryId;
  final String name;
  String? base64Image;


  Category({
    required this.categoryId,
    required this.name,
    this.base64Image,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['id'],
      name: json['name'],
    );
  }

}