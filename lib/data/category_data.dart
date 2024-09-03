class CategoryData {
  final int? ctIdx;
  final int? cstIdx;
  final String? img;
  final String? ctName;
  final List<CategoryData>? subList;

  CategoryData({
    required this.ctIdx,
    required this.cstIdx,
    required this.img,
    required this.ctName,
    required this.subList
  });

  // JSON to Object
  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      ctIdx: json['ct_idx'],
      cstIdx: json['cst_idx'],
      img: json['img'],
      ctName: json['ct_name'],
      subList: (json['subList'] as List<CategoryData>)
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'cst_idx': cstIdx,
      'img': img,
      'ct_name': ctName,
      'sub_list': subList?.map((product) => product.toJson()).toList(),
    };
  }
}