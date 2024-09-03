import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:BliU/dto/style_category_response_dto.dart';
import 'package:dio/dio.dart';

//회원관리
class MemberRepository {
  final Dio _dio = Dio();

  // 로그인
  Future<Response<dynamic>?> reqAuthLogin({
    required int id,
    required String pwd,
    required String autoLogin,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthLoginUrl,
        data: {
          'id': id.toString(),
          'pwd': pwd,
          'auto_login': autoLogin,
        },
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
        if (memberInfoResponseDTO.result == true) {
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
  // 자동 로그인
  Future<Response<dynamic>?> reqAuthAutoLogin({
    required String appToken,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthAutoLoginUrl,
        data: {
          'app_token': appToken,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
        if (memberInfoResponseDTO.result == true) {
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
  //회원가입
  Future<Response<dynamic>?> reqAuthJoin({
    required String id,
    required String pwd,
    required String pwdChk,
    required String name,
    required String phoneNum,
    required String phoneNumChk,
    required String birthDay,
    required String gender,
    required String appToken,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthJoinUrl,
        data: {
          'id': id,
          'pwd': pwd,
          'pwd_chk': pwdChk,
          'name': name,
          'phone_num': phoneNum,
          'phone_num_chk': phoneNumChk,
          'birth_day': birthDay,
          'gender': gender,
          'app_token': appToken,
        },
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

  //sns 회원가입
  Future<Response<dynamic>?> reqAuthSnsLogin({
    required String id,
    required String name,
    required String appToken,
    required String loginType,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthSnsLoginUrl,
        data: {
          'id': id,
          'name': name,
          'app_token': appToken,
          'login_type': loginType,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        MemberInfoResponseDTO defaultResponseDto = MemberInfoResponseDTO.fromJson(responseData);
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

  //아이디 중복 확인
  Future<Response<dynamic>?> reqAuthCheckId({
    required String id,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthCheckIdUrl,
        data: {
          'id': id,
        },
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
  // TODO
  //휴대폰 인증번호 발송
  Future<Response<dynamic>?> reqAuthSendCode({
    required String id,
    required String phoneNum,
    required int codeType,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthSendCodeUrl,
        data: {
          'id': id,
          'phone_num': phoneNum,
          'code_type': codeType.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //휴대폰 안중번호 인증
  Future<Response<dynamic>?> reqAuthCheckCode({
    required String appToken,
    required String phoneNum,
    required String codeNum,
    required int codeType,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthCheckCodeUrl,
        data: {
          'app_token': appToken,
          'phone_num': phoneNum,
          'code_num': codeNum,
          'code_type': codeType.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //아이디 찾기
  // TODO
  Future<Response<dynamic>?> reqAuthFindId({
    required String name,
    required String phoneNum,
    required String phoneNumChk,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthFindIdUrl,
        data: {
          'name': name,
          'phone_num': phoneNum,
          'phone_num_chk': phoneNumChk,
        },
      );

      if (response.statusCode == 200) {
        /*
         {
          "result": true,
          "data": {
              "id": "test1"
          }
        }
         * */
        Map<String, dynamic> responseData = response.data;

        if (responseData['result'] == true) {
          //성공
          String id = responseData['data']['id'];// 아이디
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
  // 비밀번호 찾기
  Future<Response<dynamic>?> reqAuthFindPwd({
    required String id,
    required String name,
    required String phoneNum,
    required String phoneNumChk,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthFindPwdUrl,
        data: {
          'id': id,
          'name': name,
          'phone_num': phoneNum,
          'phone_num_chk': phoneNumChk,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO
  //비밀번호 변경
  Future<Response<dynamic>?> reqAuthChangePwd({
    required int idx,
    required String pwd,
    required String pwdChk,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthChangePwdUrl,
        data: {
          'idx': idx.toString(),
          'pwd': pwd,
          'pwd_chk': pwdChk,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //스타일 카테고리
  Future<Response<dynamic>?> reqAuthStyleCategory() async {
    try {
      final response = await _dio.get(
        Constant.apiAuthStyleCategoryUrl
      );
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        StyleCategoryResponseDTO styleCategoryResponseDTO = StyleCategoryResponseDTO.fromJson(responseData);
        if (styleCategoryResponseDTO.result == true) {
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

  //추천 정보
  Future<Response<dynamic>?> reqAuthChildInfo({
    required int idx,
    required String birth,
    required String gender,
    required String style,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthChildInfoUrl,
        data: {
          'idx': idx.toString(),
          'birth': birth,
          'gender': gender,
          'style': style,
        },
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
}
