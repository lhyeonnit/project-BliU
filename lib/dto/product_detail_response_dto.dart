import 'package:BliU/data/info_data.dart';
import 'package:BliU/data/product_data.dart';
import 'package:BliU/data/store_data.dart';

class ProductDetailResponseDto {
  final bool? result;
  final String? message;
  final StoreData? store;
  final List<ProductData>? sameList;
  final ProductData? product;
  final InfoData? info;

  ProductDetailResponseDto({
    required this.result,
    required this.message,
    required this.store,
    required this.sameList,
    required this.product,
    required this.info,
  });

  // JSON to Object
  factory ProductDetailResponseDto.fromJson(Map<String, dynamic> json) {
    final List<ProductData>? list = List<ProductData>.from((json['data']['same_list'])?.map((item) {
      return ProductData.fromJson(item as Map<String, dynamic>);
    }).toList());

    return ProductDetailResponseDto(
      result: json['result'],
      message: json['data']['message'],
      store: StoreData.fromJson(json['data']['store']),
      sameList: list,
      product: ProductData.fromJson(json['data']['product']),
      info: InfoData.fromJson(json['data']['info']),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : {
        'store' : store?.toJson(),
        'same_list' : sameList?.map((it) => it.toJson()).toList(),
        'product' : product?.toJson(),
        'info' : info?.toJson(),
      }
    };
  }
}