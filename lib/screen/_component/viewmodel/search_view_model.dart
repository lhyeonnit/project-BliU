import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/cart_response_dto.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/pay_order_detail_dto.dart';
import 'package:BliU/dto/search_my_response_dto.dart';
import 'package:BliU/dto/search_popular_response_dto.dart';
import 'package:BliU/dto/search_response_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchModel {
  SearchResponseDTO? searchResponseDTO;

  SearchModel({
    this.searchResponseDTO,
  });
}

class SearchViewModel extends StateNotifier<SearchModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  SearchViewModel(super.state, this.ref);

  Future<SearchResponseDTO?> getSearchList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(
          url: Constant.apiSearchUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return SearchResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<SearchMyListResponseDTO?> getSearchMyList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(
          url: Constant.apiSearchMyListUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return SearchMyListResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<SearchPopularResponseDTO?> getPopularList() async {
    final response =
        await repository.reqGet(url: Constant.apiSearchPopularListUrl);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          SearchPopularResponseDTO searchPopularResponseDTO =
          SearchPopularResponseDTO.fromJson(responseData);
          return searchPopularResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error request Api: $e');
      return null;
    }
  }

  Future<DefaultResponseDTO?> searchDel(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(
          url: Constant.apiSearchMyDelUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return DefaultResponseDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }
}

// ViewModel Provider 정의
final searchModelProvider =
    StateNotifierProvider<SearchViewModel, SearchModel?>((ref) {
  return SearchViewModel(null, ref);
});
