import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/foot_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFooterModel {
  bool isExpand = true;
  FootResponseDTO? footResponseDTO;
}

class HomeFooterViewModel extends StateNotifier<HomeFooterModel> {
  final Ref ref;
  final repository = DefaultRepository();

  HomeFooterViewModel(super.state, this.ref);

  void getFoot() async {
    final response = await repository.reqGet(url: Constant.apiFootUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          FootResponseDTO footResponseDTO = FootResponseDTO.fromJson(responseData);
          state.footResponseDTO = footResponseDTO;
          ref.notifyListeners();
        }
      }
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
    }
  }

  void changeExpand() {
    state.isExpand = !state.isExpand;
    ref.notifyListeners();
  }
}

// ViewModel Provider 정의
final homeFooterViewModelProvider =
StateNotifierProvider<HomeFooterViewModel, HomeFooterModel>((ref) {
  return HomeFooterViewModel(HomeFooterModel(), ref);
});