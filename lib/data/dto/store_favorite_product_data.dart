class ProductDTO {
  final int stIdx;
  final String stName;
  final int ptIdx;
  final String ptName;
  final int ptDiscountPer;
  final int ptSellingPrice;
  final String ptImg;
  final int ptLike;
  final int ptReviewCount;
  final String likeChk;
  final String sellStatus;
  final String sellStatusTxt;

  ProductDTO({
    required this.stIdx,
    required this.stName,
    required this.ptIdx,
    required this.ptName,
    required this.ptDiscountPer,
    required this.ptSellingPrice,
    required this.ptImg,
    required this.ptLike,
    required this.ptReviewCount,
    required this.likeChk,
    required this.sellStatus,
    required this.sellStatusTxt,
  });

  // Factory method to create a ProductDTO from JSON
  factory ProductDTO.fromJson(Map<String, dynamic> json) {
    return ProductDTO(
      stIdx: json['st_idx'],
      stName: json['st_name'],
      ptIdx: json['pt_idx'],
      ptName: json['pt_name'],
      ptDiscountPer: json['pt_discount_per'],
      ptSellingPrice: json['pt_selling_price'],
      ptImg: json['pt_img'],
      ptLike: json['pt_like'],
      ptReviewCount: json['pt_review_count'],
      likeChk: json['like_chk'],
      sellStatus: json['sell_status'],
      sellStatusTxt: json['sell_status_txt'],
    );
  }

  // Method to convert a ProductDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'st_idx': stIdx,
      'st_name': stName,
      'pt_idx': ptIdx,
      'pt_name': ptName,
      'pt_discount_per': ptDiscountPer,
      'pt_selling_price': ptSellingPrice,
      'pt_img': ptImg,
      'pt_like': ptLike,
      'pt_review_count': ptReviewCount,
      'like_chk': likeChk,
      'sell_status': sellStatus,
      'sell_status_txt': sellStatusTxt,
    };
  }
}

class ProductListDTO {
  final int count;
  final List<ProductDTO> list;

  ProductListDTO({
    required this.count,
    required this.list,
  });

  // Factory method to create ProductListDTO from JSON
  factory ProductListDTO.fromJson(Map<String, dynamic> json) {
    return ProductListDTO(
      count: json['count'],
      list: (json['list'] as List).map((item) => ProductDTO.fromJson(item)).toList(),
    );
  }

  // Method to convert ProductListDTO to JSON
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'list': list.map((product) => product.toJson()).toList(),
    };
  }
}

class StoreFavoriteProductResponseDTO {
  final bool result;
  final ProductListDTO data;

  StoreFavoriteProductResponseDTO({
    required this.result,
    required this.data,
  });

  // JSON 데이터를 StoreDetailResponseDTO 객체로 변환하는 factory 메서드
  factory StoreFavoriteProductResponseDTO.fromJson(Map<String, dynamic> json) {
    return StoreFavoriteProductResponseDTO(
      result: json['result'],
      data: ProductListDTO.fromJson(json['data']),
    );
  }

  // StoreDetailResponseDTO 객체를 JSON으로 변환하는 메서드
  Map<String, dynamic> toJson() {
    return {
      'result': result,
      'data': data
    };
  }
}