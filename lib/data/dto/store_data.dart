class StoreDetailResponseDTO {
  final bool result;
  final StoreDetailDataDTO data;

  StoreDetailResponseDTO({
    required this.result,
    required this.data,
  });

  // JSON 데이터를 StoreDetailResponseDTO 객체로 변환하는 factory 메서드
  factory StoreDetailResponseDTO.fromJson(Map<String, dynamic> json) {
    return StoreDetailResponseDTO(
      result: json['result'],
      data: StoreDetailDataDTO.fromJson(json['data']),
    );
  }

  // StoreDetailResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data.toJson(),
    };
  }
}

class StoreDetailDataDTO {
  final int stIdx;
  final String stName;
  final String stProfile;
  final String stBackground;
  final int stLike;
  final String stStyle;
  final String stStyleTxt;
  final String stAge;
  final String stAgeTxt;
  final List<ProductDTO> productList;

  StoreDetailDataDTO({
    required this.stIdx,
    required this.stName,
    required this.stProfile,
    required this.stBackground,
    required this.stLike,
    required this.stStyle,
    required this.stStyleTxt,
    required this.stAge,
    required this.stAgeTxt,
    required this.productList,
  });

  // JSON 데이터를 StoreDetailDataDTO 객체로 변환하는 factory 메서드
  factory StoreDetailDataDTO.fromJson(Map<String, dynamic> json) {
    return StoreDetailDataDTO(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      stProfile: json['st_profile'],
      stBackground: json['st_background'],
      stLike: json['st_like'],
      stStyle: json['st_style'],
      stStyleTxt: json['st_style_txt'],
      stAge: json['st_age'],
      stAgeTxt: json['st_age_txt'],
      productList: (json['list'] as List).map((item) => ProductDTO.fromJson(item)).toList(),
    );
  }

  // StoreDetailDataDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'st_profile': stProfile,
      'st_background': stBackground,
      'st_like': stLike,
      'st_style': stStyle,
      'st_style_txt': stStyleTxt,
      'st_age': stAge,
      'st_age_txt': stAgeTxt,
      'list': productList.map((product) => product.toJson()).toList(),
    };
  }
}

class ProductDTO {
  final int ptIdx;
  final String ptName;
  final int ptDiscountPer;
  final int ptSellingPrice;
  final int ptPrice;
  final String ptImg;
  final int ptLike;
  final int ptReview;
  final String likeChk;
  final String sellStatus;
  final String sellStatusTxt;

  ProductDTO({
    required this.ptIdx,
    required this.ptName,
    required this.ptDiscountPer,
    required this.ptSellingPrice,
    required this.ptPrice,
    required this.ptImg,
    required this.ptLike,
    required this.ptReview,
    required this.likeChk,
    required this.sellStatus,
    required this.sellStatusTxt,
  });

  // JSON 데이터를 ProductDTO 객체로 변환하는 factory 메서드
  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
      ptDiscountPer: json['pt_discount_per'],
      ptSellingPrice: json['pt_selling_price'],
      ptPrice: json['pt_price'],
      ptImg: json['pt_img'],
      ptLike: json['pt_like'],
      ptReview: json['pt_review'],
      likeChk: json['like_chk'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
    );
  }

  // ProductDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'pt_idx': ptIdx,
      'pt_name': ptName,
      'pt_discount_per': ptDiscountPer,
      'pt_selling_price': ptSellingPrice,
      'pt_price': ptPrice,
      'pt_img': ptImg,
      'pt_like': ptLike,
      'pt_review': ptReview,
      'like_chk': likeChk,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
    };
  }
}
