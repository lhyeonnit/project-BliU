import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopCartButtonModel {
  final String? cartCount;

  TopCartButtonModel({
    required this.cartCount,
  });
}

class TopCartButtonViewModel extends StateNotifier<TopCartButtonModel?> {
  final Ref ref;
  final repository = DefaultRepository();
  TopCartButtonViewModel(super.state, this.ref);

  Future<TopCartButtonModel?> getCartCount(Map<String, dynamic> requestData) async {
    final response = await repository.reqPost(url: Constant.apiCartCountUrl, data: requestData);
    try {
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          int cartCount = responseData['data']['count'];
          state = TopCartButtonModel(cartCount: cartCount.toString());
          return state;
        }
      }
      return state;
    } catch(e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error request Api: $e');
      }
      return state;
    }
  }
}

// ViewModel Provider 정의
final topCartButtonViewModelProvider =
StateNotifierProvider<TopCartButtonViewModel, TopCartButtonModel?>((ref) {
  return TopCartButtonViewModel(null, ref);
});