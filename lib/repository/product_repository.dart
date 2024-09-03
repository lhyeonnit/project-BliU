import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/category_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_coupon_response_dto.dart';
import 'package:BliU/dto/product_list_response_dto.dart';
import 'package:BliU/dto/product_option_response_dto.dart';
import 'package:BliU/dto/product_qna_list_response_dto.dart';
import 'package:BliU/dto/qna_list_response_dto.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:dio/dio.dart';

//상품
class ProductRepository {
  final Dio _dio = Dio();

  //상품 리스트
  Future<Response<dynamic>?> reqProductList({
    required int mtIdx,
    required String category,
    required String subCategory,
    required int sort,
    required int age,
    required String styles,
    required int minPrice,
    required int maxPrice,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiProductListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'category': category,
          'sub_category': subCategory,
          'sort': sort.toString(),
          'age': age.toString(),
          'styles': styles,
          'min_price': minPrice.toString(),
          'max_price': maxPrice.toString(),
          'pg': pg.toString(),
        }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        ProductListResponseDTO defaultResponseDto = ProductListResponseDTO.fromJson(responseData);
        if (defaultResponseDto.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //상품상세
  Future<Response<dynamic>?> reqProductDetail({
    required int mtIdx,
    required int ptIdx,
    required String reload,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'pt_idx': ptIdx.toString(),
            'reload': reload,
          }
      );

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //상품 옵션
  Future<Response<dynamic>?> reqProductOption({
    required int ptIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductOptionUrl,
          data: {
            'pt_idx': ptIdx.toString(),
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        ProductOptionResponseDTO productOptionResponseDTO = ProductOptionResponseDTO.fromJson(responseData);
        if (productOptionResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //상품 쿠폰
  Future<Response<dynamic>?> reqProductCouponList({
    required int mtIdx,
    required int ptIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductCouponListUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'pt_idx': ptIdx.toString(),
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        ProductCouponResponseDTO productOptionResponseDTO = ProductCouponResponseDTO.fromJson(responseData);
        if (productOptionResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //상품 쿠폰 다운로드
  Future<Response<dynamic>?> reqProductCouponDown({
    required int mtIdx,
    required List<String> ctCodes,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductCouponDownUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'ct_codes': ctCodes,
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
        if (defaultResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //상품 좋아요
  Future<Response<dynamic>?> reqProductLike({
    required int mtIdx,
    required int ptIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductLikeUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'pt_idx': ptIdx.toString(),
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
        if (defaultResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //리뷰 리스트
  Future<Response<dynamic>?> reqProductReviewList({
    required int ptIdx,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductReviewListUrl,
          data: {
            'pt_idx': ptIdx.toString(),
            'pg': pg.toString(),
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);
        if (reviewInfoResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //리뷰 상세
  Future<Response<dynamic>?> reqProductReviewDetail({
    required int mtIdx,
    required int rtIdx,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductReviewDetailUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'rt_idx': rtIdx.toString(),
          }
      );

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //리뷰 신고
  Future<Response<dynamic>?> reqProductReviewSingo({
    required int mtIdx,
    required int rtIdx,
    required int rtCategory,
    required String rtCategoryTxt,
  }) async {
    try {
      final response = await _dio.post(
          Constant.apiProductReviewSingoUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'rt_idx': rtIdx.toString(),
            'rt_category': rtCategory.toString(),
            'rt_category_txt': rtCategoryTxt,
          }
      );

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //리뷰 신고 카테고리
  Future<Response<dynamic>?> reqProductSingoCate() async {
    try {
      final response = await _dio.get(
          Constant.apiProductSingoCateUrl,
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        CategoryResponseDTO categoryResponseDTO = CategoryResponseDTO.fromJson(responseData);
        if (categoryResponseDTO.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //문의 리스트
  Future<Response<dynamic>?> reqProductQnaList({
    required int mtIdx,
    required int ptIdx,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiProductQnaListUrl,
          data: {
            'mt_idx': mtIdx.toString(),
            'pt_idx': ptIdx.toString(),
            'pg': pg.toString(),
          }
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        ProductQnaListResponseDto productQnaListResponseDto = ProductQnaListResponseDto.fromJson(responseData);
        if (productQnaListResponseDto.result == true) {
          //성공
        } else {
          //실패
        }
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}