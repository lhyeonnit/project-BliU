import 'package:BliU/data/product_data.dart';

class ProductListResponseDTO {
  final bool result;
  final int count;
  final List<ProductData> list;

  ProductListResponseDTO({
    required this.result,
    required this.count,
    required this.list,
  });

  // JSON 데이터를 StoreDetailResponseDTO 객체로 변환하는 factory 메서드
  factory ProductListResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductListResponseDTO(
      result: json['result'],
      count: json['data']['count'],
      list: (json['data']['list'] as List).map((item) => ProductData.fromJson(item)).toList(),
    );
  }

  // StoreDetailResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': {
        'count': count,
        'list': list.map((product) => product.toJson()).toList(),
      }
    };
  }
}