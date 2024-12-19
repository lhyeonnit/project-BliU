import 'package:flutter/foundation.dart';

class OptionData {
  final int? idx;
  final String? title;
  final String? option;
  List<OptionData>? optionArr;
  final int? potPrice;
  final int? potJaego;
  int count = 1;

  OptionData({
    required this.idx,
    required this.title,
    required this.option,
    required this.optionArr,
    required this.potPrice,
    required this.potJaego,
  });

  // JSON to Object
  factory OptionData.fromJson(Map<String, dynamic> json) {
    String? option;
    List<OptionData>? optionArr;
    if (json['option'] != null) {
      var value = json['option'];
      if (value is String) {
        // String 일 경우
        option = value;
      } else {
        // List<String> 일 경우
        try {
          optionArr = List<OptionData>.from((json['option'])?.map((item) {
            return OptionData.fromJson(item as Map<String, dynamic>);
          }).toList());

        }catch(e) {
          if (kDebugMode) {
            print(e);
          }
        }
      }
    }

    return OptionData(
      idx: json['idx'],
      title: json['title'],
      option: option,
      optionArr: optionArr,
      potPrice: json['pot_price'],
      potJaego: json['pot_jaego'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'idx': idx,
      'title': title,
      'option': option ?? optionArr?.map((it) => it.toJson()).toList(),
      'pot_price': potPrice,
      'pot_jaego': potJaego,
    };
  }
}