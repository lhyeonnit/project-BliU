// import 'package:BliU/api/default_repository.dart';
// import 'package:BliU/const/constant.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class ConsumerCenterModel {
//   String? stCustomerTel;
//   String? stCustomerEmail;
//
//   ConsumerCenterModel({
//     this.stCustomerTel,
//     this.stCustomerEmail,
//   });
// }
//
// class ConsumerCenterViewModel extends StateNotifier<ConsumerCenterModel> {
//   final Ref ref;
//   final repository = DefaultRepository();
//
//   ConsumerCenterViewModel(super.state, this.ref);
//
//   Future<void> getService() async {
//     try {
//       final response = await repository.reqPost(url: Constant.apiMyPageQnaUrl);
//       if (response != null) {
//         if (response.statusCode == 200) {
//           Map<String, dynamic> responseData = response.data;
//           String? stCustomerTel = responseData['data'][0]['st_customer_tel'];
//           String? stCustomerEmail = responseData['data'][0]['st_customer_email'];
//
//           state = ConsumerCenterModel(stCustomerTel: stCustomerTel, stCustomerEmail: stCustomerEmail);
//           return;
//         }
//       }
//       state = state;
//     } catch (e) {
//       // Catch and log any exceptions
//       if (kDebugMode) {
//         print('Error fetching : $e');
//       }
//       state = state;
//     }
//   }
// }
//
// final consumerCenterViewModelProvider =
// StateNotifierProvider<ConsumerCenterViewModel, ConsumerCenterModel>((req) {
//   return ConsumerCenterViewModel(ConsumerCenterModel(), req);
// });