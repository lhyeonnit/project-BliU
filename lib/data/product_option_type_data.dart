class ProductOptionTypeData {
  final String? title;
  List<String>? children;
  String selectedValue = "";

  ProductOptionTypeData({
    required this.title,
    required this.children,
  });

  // JSON to Object
  factory ProductOptionTypeData.fromJson(Map<String, dynamic> json) {
    return ProductOptionTypeData(
      title: json['title'],
      children: List<String>.from(json['children']),
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