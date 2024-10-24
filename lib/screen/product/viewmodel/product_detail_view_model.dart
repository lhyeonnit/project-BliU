import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/product_detail_response_dto.dart';
import 'package:BliU/dto/qna_list_response_dto.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailModel {}

class ProductDetailViewModel extends StateNotifier<ProductDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductDetailViewModel(super.state, this.ref);

  Future<ProductDetailResponseDto> getDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductDetailResponseDto productDetailResponseDto = ProductDetailResponseDto.fromJson(responseData);
          return productDetailResponseDto;
        }
      }
      return ProductDetailResponseDto(
          result: false,
          message: "Network Or Data Error",
          store: null,
          sameList: null,
          product: null,
          info: null
      );
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return ProductDetailResponseDto(
          result: false,
          message: e.toString(),
          store: null,
          sameList: null,
          product: null,
          info: null
      );
    }
  }

  Future<QnaListResponseDTO?> getProductQnaList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductQnaListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          QnaListResponseDTO qnaListResponseDTO = QnaListResponseDTO.fromJson(responseData);
          return qnaListResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  Future<ReviewInfoResponseDTO?> getProductReviewList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductReviewListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);
          return reviewInfoResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  Future<DefaultResponseDTO?> productLike(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductLikeUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }
}

final productDetailModelProvider =
StateNotifierProvider<ProductDetailViewModel, ProductDetailModel?>((req) {
  return ProductDetailViewModel(null, req);
});