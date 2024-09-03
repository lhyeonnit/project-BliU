import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/search_response_dto.dart';
import 'package:dio/dio.dart';

class SearchRepository {
  final Dio _dio = Dio();

  // 인기 검색어
  Future<Response<dynamic>?> reqSearchPopularList() async {
    try {
      final response = await _dio.get(
        Constant.apiSearchPopularListUrl,
      );

      if (response.statusCode == 200 ) {
        Map<String, dynamic> responseData = response.data;
        SearchResponseDTO searchResponseDTO = SearchResponseDTO.fromJson(responseData);
        if (searchResponseDTO.result == true) {
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
  /*
   * "explan": {
        "store_search": [
          {
            "st_idx": "상점 idx",
            "st_name": "상점 이름",
            "st_profile": "상점 프로필 사진"
          }
        ],
        "product_search": [
          {
            "pt_idx": "상품 idx",
            "pt_name": "상품 이름"
          }
        ]
      },
   */
  //검색
  Future<Response<dynamic>?> reqSearch({
    required int mtIdx,
    required String token,
    required String searchTxt,
    required String research,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainPushListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'token': token,
          'search_txt': searchTxt,
          'research': research,
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  // TODO 결과값 확인 필요
  //스마트 렌즈
  Future<Response<dynamic>?> reqSearchSmartLens({
    required String searchImgPath,//Path
    required int mtIdx,
  }) async {
    try {
      var multiPartDio = Dio();
      multiPartDio.options.contentType = 'multipart/form-data';
      multiPartDio.options.maxRedirects.isFinite;

      var formData = FormData.fromMap(
          {
            'search_img': await MultipartFile.fromFile(searchImgPath),
            'mt_idx': mtIdx
          }
      );

      final response = await multiPartDio.post(
        Constant.apiSearchSmartLensUrl,
        data: formData
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //최근 검색 리스트
  Future<Response<dynamic>?> reqSearchMyList({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiSearchMyListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
        },
      );

      Map<String, dynamic> responseData = response.data;
      SearchResponseDTO searchResponseDTO = SearchResponseDTO.fromJson(responseData);
      if (searchResponseDTO.result == true) {
        //성공
      } else {
        //실패
      }

      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //최근 검색 삭제 && 최근 검색 전체삭제
  Future<Response<dynamic>?> reqSearchMyDel({
    required int mtIdx,
    required String sltIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiSearchMyDelUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'slt_idx': sltIdx,
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