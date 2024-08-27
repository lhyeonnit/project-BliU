import 'package:BliU/screen/store/viewmodel/store_favorite_view_model.dart';
import 'package:dio/dio.dart';
import 'package:BliU/data/response_dto.dart';

import '../data/dto/store_bookmark_data.dart'; // ResponseDTO에 맞게 경로 수정


class StoreRepository {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://bground.api.dmonster.kr/api/user'; // 실제 base URL로 교체

  StoreRepository() {
    _dio.options.contentType = Headers.formUrlEncodedContentType;
    _dio.options.headers['Authorization'] =
    'Bearer bground_bliu_dmonter_20240729'; // 실제 인증 토큰으로 교체
  }

  Future<ResponseDTO> fetchStore({
    required int mtIdx,
    required int stIdx,
    required int pg,
    required String category,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/store/',
        data: {
          'mt_idx': mtIdx.toString(),
          'st_idx': stIdx.toString(),
          'pg': pg.toString(),
          'category': category,
        },
      );
      if (response.statusCode == 200) {
        return ResponseDTO.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode}, ${response.data}");
        return ResponseDTO.fromJson(response.data);
      }
    } catch (e) {
      print("Error toggling store like: $e");
      return ResponseDTO(status: 500, errorMessage: 'Error', response: null);
    }
  }

  // 1. 즐겨찾기 등록/해제
  Future<ResponseDTO> toggleStoreLike({
    required int mtIdx,
    required int stIdx,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/store/like',
        data: {
          'mt_idx': mtIdx.toString(),
          'st_idx': stIdx.toString(),
        },
      );

      if (response.statusCode == 200) {
        return ResponseDTO.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode}, ${response.data}");
        return ResponseDTO.fromJson(response.data);
      }
    } catch (e) {
      print("Error toggling store like: $e");
      return ResponseDTO(status: 500, errorMessage: 'Error', response: null);
    }
  }

  // 2. 즐겨찾기 목록 조회
  Future<ResponseDTO> fetchBookmarkList(int mtIdx, int pg) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/store/bookmark',
        data: {
          'mt_idx': mtIdx.toString(),
          'pg': pg.toString(),
        },
      );

      print(response.data); // 응답 데이터 확인용

      if (response.statusCode == 200 && response.data['result'] == true) {
        // 응답 데이터를 최상위 레벨에서 Map<String, dynamic>으로 가져옴
        final Map<String, dynamic> bookmarkListJson = response.data;

        // `data` -> `list` 경로를 통해 실제 리스트를 추출
        final List<dynamic> listJson = bookmarkListJson['data']['list'];

        // Mapping JSON to BookmarkStoreDTO objects
        List<BookmarkStoreDTO> bookmarkList = listJson.map((item) {
          return BookmarkStoreDTO.fromJson(item as Map<String, dynamic>);
        }).toList();

        // 성공적으로 데이터가 반환되었을 경우, ResponseDTO로 래핑하여 반환
        return ResponseDTO(
          status: response.statusCode!,
          errorMessage: '',
          response: bookmarkList,
        );
      } else {
        // 오류가 발생한 경우 처리
        return ResponseDTO(
          status: response.statusCode!,
          errorMessage: response.data['message'] ?? 'Unknown error',
          response: null,
        );
      }
    } catch (e) {
      // 예외 발생 시 처리
      print("Error fetching bookmark list: $e");
      return ResponseDTO(
        status: 500,
        errorMessage: 'Error fetching bookmark list: $e',
        response: null,
      );
    }
  }


  // 3. 즐겨찾기한 상점의 상품 목록 조회
  Future<ResponseDTO> fetchStoreProducts({
    required int mtIdx,
    required int stIdx,
    required int pg,
    required String category,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/store/product',
        data: {
          'mt_idx': mtIdx.toString(),
          'st_idx': stIdx.toString(),
          'pg': pg.toString(),
          'category': category,
        },
      );

      if (response.statusCode == 200) {
        // Store 상품 목록 DTO로 변환
        return ResponseDTO.fromJson(response.data);
      } else {
        print("Error: ${response.statusCode}, ${response.data}");
        return ResponseDTO.fromJson(response.data);
      }
    } catch (e) {
      print("Error fetching store products: $e");
      return ResponseDTO(status: 500, errorMessage: 'Error', response: null);
    }
  }
}
