import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/product_option_type_data.dart';
import 'package:BliU/data/product_option_type_detail_data.dart';

class ProductOptionData {
  final String? ptOptionChk;
  final int? ptOptionInputNum;
  final String? ptOptionType;
  final List<ProductOptionTypeData>? ptOption;
  final List<ProductOptionTypeDetailData>? ptOptionArr;
  final List<AddOptionData>? ptAddArr;

  ProductOptionData({
    required this.ptOptionChk,
    required this.ptOptionInputNum,
    required this.ptOptionType,
    required this.ptOption,
    required this.ptOptionArr,
    required this.ptAddArr,
  });

  // JSON to Object
  factory ProductOptionData.fromJson(Map<String, dynamic> json) {
    final ptOptionList = List<ProductOptionTypeData>.from((json['pt_option'])?.map((item) {
      return ProductOptionTypeData.fromJson(item as Map<String, dynamic>);
    }).toList());

    final ptOptionArr = List<ProductOptionTypeDetailData>.from((json['pt_option_arr'])?.map((item) {
      return ProductOptionTypeDetailData.fromJson(item as Map<String, dynamic>);
    }).toList());

    final ptAddArr = List<AddOptionData>.from((json['pt_add_arr'])?.map((item) {
      return AddOptionData.fromJson(item as Map<String, dynamic>);
    }).toList());
    return ProductOptionData(
      ptOptionChk: json['pt_option_chk'],
      ptOptionInputNum: json['pt_option_input_num'],
      ptOptionType: json['pt_option_type'],
      ptOption: ptOptionList,
      ptOptionArr: ptOptionArr,
      ptAddArr: ptAddArr,
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
      'pt_add_arr': ptAddArr?.map((it) => it.toJson()).toList(),
    };
  }
}