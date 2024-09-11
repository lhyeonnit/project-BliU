import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyModel {
  MemberInfoResponseDTO? memberInfoResponseDTO;

  MyModel({
    this.memberInfoResponseDTO,
  });
}

class MyViewModel extends StateNotifier<MyModel?>{
  final Ref ref;
  final repository = DefaultRepository();

  MyViewModel(super.state, this.ref);

  Future<void> getMy(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
          state = MyModel(memberInfoResponseDTO: memberInfoResponseDTO);
          return;
        }
      }
      state = MyModel(
          memberInfoResponseDTO: MemberInfoResponseDTO(
              result: false,
              message: "Network Or Data Error",
              data: null
          )
      );
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      state = MyModel(
          memberInfoResponseDTO: MemberInfoResponseDTO(
              result: false,
              message: e.toString(),
              data: null
          )
      );
    }
  }
}


final myModelProvider =
StateNotifierProvider<MyViewModel, MyModel?>((req) {
  return MyViewModel(null, req);
});