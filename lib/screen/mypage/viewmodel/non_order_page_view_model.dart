import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NonOrderPageModel {}

class NonOrderPageViewModel extends StateNotifier<NonOrderPageModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  NonOrderPageViewModel(super.state, this.ref);

  Future<Map<String, dynamic>?> getFindOrder(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageFindOrder, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return responseData;
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

final nonOrderPageViewModelProvider =
StateNotifierProvider<NonOrderPageViewModel, NonOrderPageModel?>((req) {
  return NonOrderPageViewModel(null, req);
});