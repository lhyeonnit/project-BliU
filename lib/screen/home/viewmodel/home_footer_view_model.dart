import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/foot_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFooterModel {
  final FootResponseDTO? footResponseDTO;

  HomeFooterModel({
    required this.footResponseDTO,
  });
}

class HomeFooterViewModel extends StateNotifier<HomeFooterModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeFooterViewModel(super.state, this.ref){
    getFoot();
  }

  Future<void> getFoot() async {
    final response = await repository.reqGet(url: Constant.apiFootUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FootResponseDTO footResponseDTO = FootResponseDTO.fromJson(responseData);
          state = HomeFooterModel(footResponseDTO: footResponseDTO);
          return;
        }
      }
      state = HomeFooterModel(footResponseDTO: FootResponseDTO(result: false, message: "Network Or Data Error"));
    } catch(e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      state = HomeFooterModel(footResponseDTO: FootResponseDTO(result: false, message: e.toString()));
    }
  }
}

// ViewModel Provider 정의
final footerViewModelProvider =
StateNotifierProvider<HomeFooterViewModel, HomeFooterModel?>((ref) {
  return HomeFooterViewModel(null, ref);
});