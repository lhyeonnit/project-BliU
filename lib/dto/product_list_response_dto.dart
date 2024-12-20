import 'package:BliU/data/product_data.dart';
import 'package:flutter/foundation.dart';

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
    final list = List<ProductData>.from((json['data']['list'])?.map((item) {
      return ProductData.fromJson(item as Map<String, dynamic>);
    }).toList());

    int count = 0;
    try {
      if (json['data']['count'] != null) {
        count = json['data']['count'];
      }
    } catch (e) {
      if (kDebugMode) {
        print("e = ${e.toString()}");
      }
    }

    return ProductListResponseDTO(
      result: json['result'],
      count: count,
      list: list,
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