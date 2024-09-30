import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/product_detail_response_dto.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailModel {
  ProductDetailResponseDto? productDetailResponseDto;
  ReviewInfoResponseDTO? reviewInfoResponseDTO;

  ProductDetailModel({
    this.productDetailResponseDto,
    this.reviewInfoResponseDTO,
  });
}

class ProductDetailViewModel extends StateNotifier<ProductDetailModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductDetailViewModel(super.state, this.ref);

  Future<void> getDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ProductDetailResponseDto productDetailResponseDto = ProductDetailResponseDto.fromJson(responseData);
          state = ProductDetailModel(productDetailResponseDto: productDetailResponseDto, reviewInfoResponseDTO: state?.reviewInfoResponseDTO);
          return;
        }
      }
      state = ProductDetailModel(
        productDetailResponseDto: ProductDetailResponseDto(
          result: false,
          message: "Network Or Data Error",
          store: null,
          sameList: null,
          product: null,
          info: null
        )
      );
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = ProductDetailModel(
        productDetailResponseDto: ProductDetailResponseDto(
          result: false,
          message: e.toString(),
          store: null,
          sameList: null,
          product: null,
          info: null
        )
      );
    }
  }

  Future<void> getReviewList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductReviewListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);
          state = ProductDetailModel(productDetailResponseDto: state?.productDetailResponseDto, reviewInfoResponseDTO: reviewInfoResponseDTO);
          return;
        }
      }
      state = ProductDetailModel(
          productDetailResponseDto: state?.productDetailResponseDto,
          reviewInfoResponseDTO: ReviewInfoResponseDTO(
              result: false,
              message: "Network Or Data Error",
          )
      );
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = ProductDetailModel(
          productDetailResponseDto: state?.productDetailResponseDto,
          reviewInfoResponseDTO: ReviewInfoResponseDTO(
            result: false,
            message: e.toString(),
          )
      );
    }
  }
}

final productDetailModelProvider =
StateNotifierProvider<ProductDetailViewModel, ProductDetailModel?>((req) {
  return ProductDetailViewModel(null, req);
});