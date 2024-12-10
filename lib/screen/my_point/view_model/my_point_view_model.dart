import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/point_data.dart';
import 'package:BliU/dto/point_list_response_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPointModel {
  int selectedCategoryIndex = 0;

  int mtPoint = 0;
  List<PointData> pointList = [];

  int page = 1;
  bool hasNextPage = true;
  bool isFirstLoadRunning = false;
  bool isLoadMoreRunning = false;
}

class MyPointViewModel extends StateNotifier<MyPointModel> {
  final Ref ref;
  final repository = DefaultRepository();

  MyPointViewModel(super.state, this.ref);

  void listLoad(Map<String, dynamic> requestData) async {
    state.isFirstLoadRunning = true;
    state.page = 1;
    state.hasNextPage = true;

    requestData.addAll({
      'pg': state.page,
    });

    state.mtPoint = 0;
    state.pointList = [];
    ref.notifyListeners();

    final pointListResponseDTO = await _getList(requestData);
    state.mtPoint = pointListResponseDTO?.mtPoint ?? 0;
    state.pointList = pointListResponseDTO?.list ?? [];

    state.isFirstLoadRunning = false;

    ref.notifyListeners();
  }

  void listNextLoad(Map<String, dynamic> requestData) async {
    if (state.hasNextPage && !state.isFirstLoadRunning && !state.isLoadMoreRunning){
      state.isLoadMoreRunning = true;
      state.page += 1;

      requestData.addAll({
        'pg': state.page,
      });

      final pointListResponseDTO = await _getList(requestData);
      if (pointListResponseDTO != null) {
        if ((pointListResponseDTO.list ?? []).isNotEmpty) {
          state.pointList.addAll(pointListResponseDTO.list ?? []);
        } else {
          state.hasNextPage = false;
        }
        ref.notifyListeners();
      }

      state.isLoadMoreRunning = false;
    }
  }

  Future<PointListResponseDTO?> _getList(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPagePointUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          PointListResponseDTO pointListResponseDTO = PointListResponseDTO.fromJson(responseData);
          return pointListResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      return null;
    }
  }

  void setSelectedCategoryIndex(int index) {
    state.selectedCategoryIndex = index;
    ref.notifyListeners();
  }
}

final myPointViewModelProvider =
StateNotifierProvider<MyPointViewModel, MyPointModel>((req) {
  return MyPointViewModel(MyPointModel(), req);
});