import 'package:BliU/data/dto/product_option_type_data.dart';
import 'package:BliU/data/dto/product_option_type_detail_data.dart';

class ProductOptionDTO {
  final String? ptOptionChk;
  final int? ptOptionInputNum;
  final String? ptOptionType;
  final List<ProductOptionTypeDTO>? ptOption;
  final List<ProductOptionTypeDetailDTO>? ptOptionArr;

  ProductOptionDTO({
    required this.ptOptionChk,
    required this.ptOptionInputNum,
    required this.ptOptionType,
    required this.ptOption,
    required this.ptOptionArr,
  });

  // JSON to Object
  factory ProductOptionDTO.fromJson(Map<String, dynamic> json) {
    return ProductOptionDTO(
      ptOptionChk: json['pt_option_chk'],
      ptOptionInputNum: json['pt_option_input_num'],
      ptOptionType: json['pt_option_type'],
      ptOption: (json['pt_option'] as List<ProductOptionTypeDTO>),
      ptOptionArr: (json['pt_option_arr'] as List<ProductOptionTypeDetailDTO>),
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'pt_option_chk': ptOptionChk,
      'pt_option_input_num': ptOptionInputNum,
      'pt_option_type': ptOptionType,
      'pt_option': ptOption?.map((it) => it.toJson()).toList(),
      'pt_option_arr': ptOptionArr?.map((it) => it.toJson()).toList(),
    };
  }
}

class ProductOptionResponseDTO {
  final bool? result;
  final String? message;
  final ProductOptionDTO? data;

  ProductOptionResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory ProductOptionResponseDTO.fromJson(Map<String, dynamic> json) {
    return ProductOptionResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as ProductOptionDTO),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': data?.toJson()
    };
  }
}