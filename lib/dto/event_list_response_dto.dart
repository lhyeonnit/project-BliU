import 'package:BliU/data/event_data.dart';

class EventListResponseDTO {
  final bool? result;
  final String? message;
  final int? count;
  final List<EventData>? list;

  EventListResponseDTO({
    required this.result,
    required this.message,
    required this.count,
    required this.list
  });

  // JSON to Object
  factory EventListResponseDTO.fromJson(Map<String, dynamic> json) {
    return EventListResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      count: json['data']['count'],
      list: (json['data']['list'] as List<EventData>),
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'message': message,
      'data': {
        'count': count,
        'list': list?.map((it) => it.toJson()).toList(),
      }
    };
  }
}