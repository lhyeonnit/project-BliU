class ProductAttributeData {
  final String? title;
  final String? patType;
  final String? patName;
  final String? patKc;
  final String? patSize;
  final String? patColor;
  final String? patTexture;
  final String? patAge;
  final String? patSdate;
  final String? patImporter;
  final String? patFrom;
  final String? patDanger;
  final String? patQuality;
  final String? patAs;
  final String? patKind;

  ProductAttributeData({
    required this.title,
    required this.patType,
    required this.patName,
    required this.patKc,
    required this.patSize,
    required this.patColor,
    required this.patTexture,
    required this.patAge,
    required this.patSdate,
    required this.patImporter,
    required this.patFrom,
    required this.patDanger,
    required this.patQuality,
    required this.patAs,
    required this.patKind,
  });

  factory ProductAttributeData.fromJson(Map<String, dynamic> json) {

    return ProductAttributeData(
      title: json['title'],
      patType: json['pat_type'],
      patName: json['pat_name'],
      patKc: json['pat_kc'],
      patSize: json['pat_size'],
      patColor: json['pat_color'],
      patTexture: json['pat_texture'],
      patAge: json['pat_age'],
      patSdate: json['pat_sdate'],
      patImporter: json['pat_importer'],
      patFrom: json['pat_from'],
      patDanger: json['pat_danger'],
      patQuality: json['pat_quality'],
      patAs: json['pat_as'],
      patKind: json['pat_kind'],
    );
  }

  Map<String, dynamic> toJson() => {
    'title' : title,
    'pat_type' : patType,
    'pat_name' : patName,
    'pat_kc' : patKc,
    'pat_size' : patSize,
    'pat_color' : patColor,
    'pat_texture' : patTexture,
    'pat_age' : patAge,
    'pat_sdate' : patSdate,
    'pat_importer' : patImporter,
    'pat_from' : patFrom,
    'pat_danger' : patDanger,
    'pat_quality' : patQuality,
    'pat_as' : patAs,
    'pat_kind' : patKind,
  };
}