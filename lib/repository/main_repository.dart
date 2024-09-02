import 'package:BliU/const/constant.dart';
import 'package:dio/dio.dart';

//홈
class MainRepository {
  final Dio _dio = Dio();

  //배너 리스트
  Future<Response<dynamic>?> reqMainBannerList() async {
    try {
      final response = await _dio.get(
        Constant.apiAuthChildInfoUrl,
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //배너 이벤트 상세
  Future<Response<dynamic>?> reqMainBannerDetail({
    required int btIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiAuthChildInfoUrl,
        data: {
          'bt_idx': btIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //카테고리 리스트
  Future<Response<dynamic>?> reqMainCategory({
    required int categoryType,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainCategoryUrl,
        data: {
          'category_type': categoryType.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //기획전 리스트
  Future<Response<dynamic>?> reqMainExhibitionList({
    required int btIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainExhibitionListUrl,
        data: {
          'bt_idx': btIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //기획전 상세
  Future<Response<dynamic>?> reqMainExhibitionDetail({
    required int etIdx,
    required int mtIdx,
    required int pg,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainExhibitionListUrl,
        data: {
          'et_idx': etIdx.toString(),
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
  // TODO 결과값 확인 필요
  //ai 추천 리스트
  Future<Response<dynamic>?> reqMainAiList({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainAiListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //판매 베스트
  Future<Response<dynamic>?> reqMainSellRank({
    required int mtIdx,
    required String category,
    required int age,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainSellRankUrl,
        data: {
          'mt_idx': mtIdx.toString(),
          'category': category,
          'age': age.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
  //알림 리스트
  Future<Response<dynamic>?> reqMainPushList({
    required int mtIdx,
  }) async {
    try {
      final response = await _dio.post(
        Constant.apiMainPushListUrl,
        data: {
          'mt_idx': mtIdx.toString(),
        },
      );
      return response;
    } catch (e) {
      print("Error toggling store like: $e");
      return null;
    }
  }
}