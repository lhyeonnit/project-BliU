class ProductOptionTypeDTO {
  final String? title;
  final List<String>? children;

  ProductOptionTypeDTO({
    required this.title,
    required this.children,
  });

  // JSON to Object
  factory ProductOptionTypeDTO.fromJson(Map<String, dynamic> json) {
    return ProductOptionTypeDTO(
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