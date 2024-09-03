class FootData {
  final String? stCompanyName;
  final String? stCompanyBoss;
  final String? stCompanyNum1;
  final String? stCompanyNum2;
  final String? stCompanyAdd;

  FootData({
    required this.stCompanyName,
    required this.stCompanyBoss,
    required this.stCompanyNum1,
    required this.stCompanyNum2,
    required this.stCompanyAdd,
  });

  // JSON to Object
  factory FootData.fromJson(Map<String, dynamic> json) {
    return FootData(
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