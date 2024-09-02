class EventDTO {
  final int? btIdx;
  final String? btTitle;
  final String? btContent;
  final String? btImg;
  final String? btWdate;

  EventDTO({
    required this.btIdx,
    required this.btTitle,
    required this.btContent,
    required this.btImg,
    required this.btWdate,
  });

  // JSON to Object
  factory EventDTO.fromJson(Map<String, dynamic> json) {
    return EventDTO(
      btIdx: json['bt_idx'],
      btTitle: json['bt_title'],
      btContent: json['bt_content'],
      btImg: json['bt_img'],
      btWdate: json['bt_wdate'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'bt_idx': btIdx,
      'bt_title': btTitle,
      'bt_content': btContent,
      'bt_img': btImg,
      'bt_wdate': btWdate,
    };
  }
}

class EventListResponseDTO {

}

class EventDetailResponseDTO {

}