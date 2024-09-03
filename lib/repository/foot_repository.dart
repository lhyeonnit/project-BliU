import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/foot_response_dto.dart';
import 'package:dio/dio.dart';

//푸터
class FootRepository {
  final Dio _dio = Dio();

  // 푸터
  Future<Response<dynamic>?> reqFoot() async {
    try {
      final response = await _dio.get(
        Constant.apiFootUrl,
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        FootResponseDTO footResponseDTO = FootResponseDTO.fromJson(responseData);
        if (footResponseDTO.result == true) {
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