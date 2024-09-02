class FootDTO {
  final String? stCompanyName;
  final String? stCompanyBoss;
  final String? stCompanyNum1;
  final String? stCompanyNum2;
  final String? stCompanyAdd;

  FootDTO({
    required this.stCompanyName,
    required this.stCompanyBoss,
    required this.stCompanyNum1,
    required this.stCompanyNum2,
    required this.stCompanyAdd,
  });

  // JSON to Object
  factory FootDTO.fromJson(Map<String, dynamic> json) {
    return FootDTO(
      stCompanyName: json['st_company_name'],
      stCompanyBoss: json['st_company_boss'],
      stCompanyNum1: json['st_company_num1'],
      stCompanyNum2: json['st_company_num2'],
      stCompanyAdd: json['st_company_add'],
    );
  }

  // Object to JSOn
  Map<String, dynamic> toJson() {
    return {
      'st_company_name': stCompanyName,
      'st_company_boss': stCompanyBoss,
      'st_company_num1': stCompanyNum1,
      'st_company_num2': stCompanyNum2,
      'st_company_add': stCompanyAdd,
    };
  }
}

class FootResponseDTO {
  final bool? result;
  final String? message;
  final FootDTO? data;

  FootResponseDTO({
    required this.result,
    required this.message,
    required this.data
  });

  // JSON to Object
  factory FootResponseDTO.fromJson(Map<String, dynamic> json) {
    return FootResponseDTO(
      result: json['result'],
      message: json['data']['message'],
      data: (json['data'][0] as FootDTO),
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