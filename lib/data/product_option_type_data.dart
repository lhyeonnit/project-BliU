class ProductOptionTypeData {
  final String? title;
  final List<String>? children;

  ProductOptionTypeData({
    required this.title,
    required this.children,
  });

  // JSON to Object
  factory ProductOptionTypeData.fromJson(Map<String, dynamic> json) {
    return ProductOptionTypeData(
      title: json['title'],
      children: (json['children'] as List<String>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'children': children,
    };
  }
}