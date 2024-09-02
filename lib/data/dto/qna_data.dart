import 'package:BliU/data/dto/store_favorite_product_data.dart';

class QnaDTO {
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
  final ProductDTO? product;

  QnaDTO({
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
    required this.product,
  });

  // JSON to Object
  factory QnaDTO.fromJson(Map<String, dynamic> json) {
    return QnaDTO(
      myQna: json['my_qna'],
      qtIdx: json['qt_idx'],
      mtId: json['mt_id'],
      qtStatus: json['qt_status'],
      qtStatusTxt: json['qt_status_txt'],
      qtTitle: json['qt_title'],
      qtWdate: json['qt_wdate'],
      qtUdate: json['qt_udate'],
      qtContent: json['qt_content'],
      qtContentImg: json['qt_content_img'],
      qtAnswer: json['qt_answer'],
      product: json['product'],
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
      'qt_content_img': qtContentImg,
      'qt_answer': qtAnswer,
      'product': product,
    };
  }
}

class QnaResponseDTO {
  final bool? result;
  final String? message;
  final List<QnaDTO>? data;

  QnaResponseDTO({
    required this.result,
    required this.message,
    required this.data,
  });

  // JSON to Object
  factory QnaResponseDTO.fromJson(Map<String, dynamic> json) {
    return QnaResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'] as List<QnaDTO>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data' : data?.map((it) => it.toJson()).toList(),
    };
  }
}