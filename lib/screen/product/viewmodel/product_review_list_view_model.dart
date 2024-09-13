import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/review_data.dart';
import 'package:BliU/dto/review_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductReviewListModel {
  ReviewInfoResponseDTO? reviewInfoResponseDTO;

  ProductReviewListModel({
    this.reviewInfoResponseDTO,
  });
}

class ProductReviewListViewModel extends StateNotifier<ProductReviewListModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ProductReviewListViewModel(super.state, this.ref);

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiProductReviewListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          ReviewInfoResponseDTO reviewInfoResponseDTO = ReviewInfoResponseDTO.fromJson(responseData);

          var list = state?.reviewInfoResponseDTO?.list ?? [];
          List<ReviewData> addList = reviewInfoResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          reviewInfoResponseDTO.list = list;

          state = ProductReviewListModel(reviewInfoResponseDTO: reviewInfoResponseDTO);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = state;
    }
  }
}

final productReviewListModelProvider =
StateNotifierProvider<ProductReviewListViewModel, ProductReviewListModel?>((req) {
  return ProductReviewListViewModel(null, req);
});