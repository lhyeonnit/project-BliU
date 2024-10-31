import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceModel {
  String? stCustomerTel;
  String? stCustomerEmail;

  ServiceModel({
    this.stCustomerTel,
    this.stCustomerEmail,
  });
}

class ServiceViewModel extends StateNotifier<ServiceModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  ServiceViewModel(super.state, this.ref);

  Future<void> getService() async {
    try {
      final response = await repository.reqPost(url: Constant.apiMyPageQnaUrl);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          String? stCustomerTel = responseData['data'][0]['st_customer_tel'];
          String? stCustomerEmail = responseData['data'][0]['st_customer_email'];

          state = ServiceModel(stCustomerTel: stCustomerTel, stCustomerEmail: stCustomerEmail);
          return;
        }
      }
      state = state;
    } catch (e) {
      // Catch and log any exceptions
      if (kDebugMode) {
        print('Error fetching : $e');
      }
      state = state;
    }
  }
}

final serviceViewModelProvider =
StateNotifierProvider<ServiceViewModel, ServiceModel?>((req) {
  return ServiceViewModel(null, req);
});