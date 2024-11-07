import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyModel {
  MemberInfoResponseDTO? memberInfoResponseDTO;
}

class MyViewModel extends StateNotifier<MyModel>{
  final Ref ref;
  final repository = DefaultRepository();

  MyViewModel(super.state, this.ref);

  void getMy(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          state.memberInfoResponseDTO = memberInfoResponseDTO;
          ref.notifyListeners();
          return;
        }
      }
      state.memberInfoResponseDTO = null;
      ref.notifyListeners();
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state.memberInfoResponseDTO = null;
      ref.notifyListeners();
    }
  }

  void resetData() {
    state.memberInfoResponseDTO = null;
    ref.notifyListeners();
  }
}


final myViewModelProvider =
StateNotifierProvider<MyViewModel, MyModel>((req) {
  return MyViewModel(MyModel(), req);
});