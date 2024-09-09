import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/faq_category_data.dart';
import 'package:BliU/data/faq_data.dart';
import 'package:BliU/dto/faq_category_response_dto.dart';
import 'package:BliU/dto/faq_response_dto.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FaqModel {
  FaqResponseDTO? faqResponseDTO;

  FaqModel({
    this.faqResponseDTO,
  });
}

class FaqViewModel extends StateNotifier<FaqModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  FaqViewModel(super.state, this.ref);

  Future<List<FaqCategoryData>?> getCategory() async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqCategoryUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqCategoryResponseDTO faqCategoryResponseDTO = FaqCategoryResponseDTO.fromJson(responseData);
          return faqCategoryResponseDTO.list;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<void> getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFaqUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FaqResponseDTO faqResponseDTO = FaqResponseDTO.fromJson(responseData);

          var list = state?.faqResponseDTO?.list ?? [];
          List<FaqData> addList = faqResponseDTO.list ?? [];
          for (var item in  addList) {
            list.add(item);
          }

          faqResponseDTO.list = list;

          state = FaqModel(faqResponseDTO: faqResponseDTO);
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

final faqModelProvider =
StateNotifierProvider<FaqViewModel, FaqModel?>((req) {
  return FaqViewModel(null, req);
});