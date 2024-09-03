import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

class StoreRepository {
  final Dio _dio = Dio();


  Future<Response<dynamic>?> fetchStore({
    required int mtIdx,
    required int stIdx,
    required int pg,
    required String category,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiStoreUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'st_idx': stIdx.toString(),
          'pg': pg.toString(),
          'category': category,
        },
      );
      return response;

    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }


  // 1. 즐겨찾기 등록/해제
  Future<Response<dynamic>?> toggleStoreLike({
    required int mtIdx,
    required int stIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiStoreLikeUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'st_idx': stIdx.toString(),
        },
      );

      return response;

    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }

  // 2. 즐겨찾기 목록 조회
  Future<Response<dynamic>?> fetchBookmarkList({required int mtIdx, required int pg}) async {
    try {
      final response = await _dio.post(
        Constant.apiStoreBookMarkUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'pg': pg.toString(),
        },
      );

      return response;

    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }

  // 3. 즐겨찾기한 상점의 상품 목록 조회
  Future<Response<dynamic>?> fetchStoreProducts({
    required int mtIdx,
    required int pg,
    required String searchTxt,
    required String category,
    required String age,
    required int sort}) async {
    try {
      final response = await _dio.post(
        Constant.apiStoreProductsUrl,
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'mt_idx': mtIdx.toString(),
          'pg': pg.toString(),
          'search_txt': searchTxt,
          'category': category,
          'age': age,
          'sort': sort.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}