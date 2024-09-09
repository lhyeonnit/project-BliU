import 'package:BliU/data/event_data.dart';

class EventDetailResponseDTO {
  final bool? result;
  final String? message;
  final EventData? data;

  EventDetailResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory EventDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return EventDetailResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: EventData.fromJson(json['data']),
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