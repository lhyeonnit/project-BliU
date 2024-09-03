import 'package:BliU/data/product_option_type_data.dart';
import 'package:BliU/data/product_option_type_detail_data.dart';

class ProductOptionData {
  final String? ptOptionChk;
  final int? ptOptionInputNum;
  final String? ptOptionType;
  final List<ProductOptionTypeData>? ptOption;
  final List<ProductOptionTypeDetailData>? ptOptionArr;

  ProductOptionData({
    required this.ptOptionChk,
    required this.ptOptionInputNum,
    required this.ptOptionType,
    required this.ptOption,
    required this.ptOptionArr,
  });

  // JSON to Object
  factory ProductOptionData.fromJson(Map<String, dynamic> json) {
    return ProductOptionData(
      ptOptionChk: json['pt_option_chk'],
      ptOptionInputNum: json['pt_option_input_num'],
      ptOptionType: json['pt_option_type'],
      ptOption: (json['pt_option'] as List<ProductOptionTypeData>),
      ptOptionArr: (json['pt_option_arr'] as List<ProductOptionTypeDetailData>),
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