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
  final String? couponEnable;

  ProductDetailResponseDto({
    required this.result,
    required this.message,
    required this.store,
    required this.sameList,
    required this.product,
    required this.info,
    required this.couponEnable,
  });

  // JSON to Object
  factory ProductDetailResponseDto.fromJson(Map<String, dynamic> json) {
    List<ProductData> list = [];
    if (json['data']['same_list'] != null) {
      list = List<ProductData>.from((json['data']['same_list'])?.map((item) {
        return ProductData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }
    StoreData? storeData;
    if (json['data']['store'] != null) {
      storeData = StoreData.fromJson(json['data']['store']);
    }
    ProductData? productData;
    if (json['data']['product'] != null) {
      productData = ProductData.fromJson(json['data']['product']);
    }
    InfoData? infoData;
    if (json['data']['info'] != null) {
      infoData = InfoData.fromJson(json['data']['info']);
    }

    return ProductDetailResponseDto(
      result: json['result'],
      message: json['data']['message'],
      store: storeData,
      sameList: list,
      product: productData,
      info: infoData,
      couponEnable: json['data']['coupon_enable'],
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
        'coupon_enable' : couponEnable,
      }
    };
  }
}