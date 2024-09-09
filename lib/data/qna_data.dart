import 'dart:convert';

import 'package:BliU/data/product_data.dart';

class QnaData {
  final String? myQna;
  final int? qtIdx;
  final String? mtId;
  final String? qtStatus;
  final String? qtStatusTxt;
  final String? qtTitle;
  final String? qtWdate;
  final String? qtUdate;
  final String? qtContent;
  final List<String>? qtContentImg;
  final String? qtAnswer;
  final String? stProfile;
  final ProductData? product;

  QnaData({
    required this.myQna,
    required this.qtIdx,
    required this.mtId,
    required this.qtStatus,
    required this.qtStatusTxt,
    required this.qtTitle,
    required this.qtWdate,
    required this.qtUdate,
    required this.qtContent,
    required this.qtContentImg,
    required this.qtAnswer,
    required this.stProfile,
    required this.product,
  });

  // JSON to Object
  factory QnaData.fromJson(Map<String, dynamic> json) {
    ProductData? product;
    if (json['product'] != null) {
      product = ProductData.fromJson(json['product']);
    }
    List<String>? qtContentImg;
    if (json['qt_content_img'] != null) {
      qtContentImg = List<String>.from(json['qt_content_img']);
    }

    return QnaData(
      myQna: json['my_qna'],
      qtIdx: json['qt_idx'],
      mtId: json['mt_id'],
      qtStatus: json['qt_status'],
      qtStatusTxt: json['qt_status_txt'],
      qtTitle: json['qt_title'],
      qtWdate: json['qt_wdate'],
      qtUdate: json['qt_udate'],
      qtContent: json['qt_content'],
      qtContentImg: qtContentImg,
      qtAnswer: json['qt_answer'],
      stProfile: json['st_profile'],
      product: product,
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'my_qna': myQna,
      'qt_idx': qtIdx,
      'mt_id': mtId,
      'qt_status': qtStatus,
      'qt_status_txt': qtStatusTxt,
      'qt_title': qtTitle,
      'qt_wdate': qtWdate,
      'qt_udate': qtUdate,
      'qt_content': qtContent,
      'qt_content_img': json.encode(qtContentImg),
      'qt_answer': qtAnswer,
      'st_profile': stProfile,
      'product': product?.toJson(),
    };
  }
}