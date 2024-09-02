import 'package:BliU/data/dto/store_favorite_product_data.dart';

class ExhibitionDTO {
  final int? etIdx;
  final String? etTitle;
  final String? etSubTitle;
  final String? etBanner;
  final int? etProductCount;
  final List<ProductDTO>? product;

  ExhibitionDTO({
    required this.etIdx,
    required this.etTitle,
    required this.etSubTitle,
    required this.etBanner,
    required this.etProductCount,
    required this.product,
  });

  // JSON to Object
  factory ExhibitionDTO.fromJson(Map<String, dynamic> json) {
    return ExhibitionDTO(
      etIdx: json['et_idx'],
      etTitle: json['et_title'],
      etSubTitle: json['et_sub_title'],
      etBanner: json['et_banner'],
      etProductCount: json['et_product_count'],
      product: (json['product'] as List<ProductDTO>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'et_idx': etIdx,
      'et_title': etTitle,
      'et_sub_title': etSubTitle,
      'et_banner': etBanner,
      'et_product_count': etProductCount,
      'product': product?.map((it) => it.toJson()).toList(),
    };
  }
}

class ExhibitionListResponseDTO {
  final bool? result;
  final String? message;
  final List<ExhibitionDTO>? list;

  ExhibitionListResponseDTO({
    required this.result,
    required this.message,
    required this.list
  });

  // JSON to Object
  factory ExhibitionListResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExhibitionListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      list: (json['data']['list'] as List<ExhibitionDTO>),
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

class ExhibitionDetailResponseDTO {
  final bool? result;
  final String? message;
  final ExhibitionDTO? data;

  ExhibitionDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory ExhibitionDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return ExhibitionDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as ExhibitionDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson(),
    };
  }
}