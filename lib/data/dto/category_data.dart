class CategoryDTO {
  final int? ctIdx;
  final String? img;
  final String? ctName;
  final List<CategoryDTO>? subList;

  CategoryDTO({
    required this.ctIdx,
    required this.img,
    required this.ctName,
    required this.subList
  });

  // JSON to Object
  factory CategoryDTO.fromJson(Map<String, dynamic> json) {
    return CategoryDTO(
      ctIdx: json['ct_idx'],
      img: json['img'],
      ctName: json['ct_name'],
      subList: (json['subList'] as List<CategoryDTO>)
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'ct_idx': ctIdx,
      'img': img,
      'ct_name': ctName,
      'sub_list': subList?.map((product) => product.toJson()).toList(),
    };
  }
}

class CategoryResponseDTO {
  final bool? result;
  final String? message;
  final List<CategoryDTO>? list;

  CategoryResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory CategoryResponseDTO.fromJson(Map<String, dynamic> json) {
    return CategoryResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<CategoryDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}