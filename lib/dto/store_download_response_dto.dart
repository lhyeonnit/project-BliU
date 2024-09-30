
class StoreDownloadResponseDTO {
  final bool? result;
  final String? data;

  StoreDownloadResponseDTO({
    required this.result,
    required this.data,
  });

  // JSON to Object
  factory StoreDownloadResponseDTO.fromJson(Map<String, dynamic> json) {
    return StoreDownloadResponseDTO(
      result: json['result'],
      data: json['data'],
    );
  }

  // Object to JSON
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data,
    };
  }
}