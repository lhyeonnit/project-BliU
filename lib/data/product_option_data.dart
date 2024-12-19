import 'package:BliU/data/add_option_data.dart';
import 'package:BliU/data/option_data.dart';

class ProductOptionData {
  final String? ptType;
  final String? ptTypeText;
  final List<String>? ptOptionSelect;
  final List<OptionData>? ptOption;
  final List<AddOptionData>? ptAddOption;

  ProductOptionData({
    required this.ptType,
    required this.ptTypeText,
    required this.ptOptionSelect,
    required this.ptOption,
    required this.ptAddOption,
  });

  // JSON to Object
  factory ProductOptionData.fromJson(Map<String, dynamic> json) {
    List<String> ptOptionSelect = [];
    if (json['pt_option_select'] != null) {
      ptOptionSelect = List<String>.from(json['pt_option_select']);
    }

    List<OptionData> ptOption = [];
    if (json['pt_option'] != null) {
      ptOption = List<OptionData>.from((json['pt_option'])?.map((item) {
        return OptionData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    List<AddOptionData> ptAddOption = [];
    if (json['pt_add_option'] != null) {
      ptAddOption = List<AddOptionData>.from((json['pt_add_option'])?.map((item) {
        return AddOptionData.fromJson(item as Map<String, dynamic>);
      }).toList());
    }

    return ProductOptionData(
      ptType: json['pt_type'],
      ptTypeText: json['pt_type_text'],
      ptOptionSelect: ptOptionSelect,
      ptOption:ptOption,
      ptAddOption: ptAddOption,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'pt_type': ptType,
      'pt_type_text': ptTypeText,
      'pt_option_select': ptOptionSelect,
      'pt_option': ptOption?.map((it) => it.toJson()).toList(),
      'pt_add_option': ptAddOption?.map((it) => it.toJson()).toList(),
    };
  }
}