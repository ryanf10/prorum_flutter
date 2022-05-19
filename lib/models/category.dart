class Category{
  final int categoryId;
  final String name;

  const Category({
    required this.categoryId,
    required this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['id'],
      name: json['name'],
    );
  }

}