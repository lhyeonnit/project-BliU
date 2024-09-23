import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/default_response_dto.dart';
import 'package:BliU/dto/pay_order_detail_dto.dart';
import 'package:BliU/dto/pay_order_result_detail_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentModel {

}

class PaymentViewModel extends StateNotifier<PaymentModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  PaymentViewModel(super.state, this.ref);

  Future<PayOrderDetailDTO?> orderDetail(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderDetailUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          return PayOrderDetailDTO.fromJson(responseData);
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> reqOrder(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderUrl, data: requestData);
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
  //결제 검증
  Future<DefaultResponseDTO?> orderCheck(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderCheckUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          DefaultResponseDTO defaultResponseDTO = DefaultResponseDTO.fromJson(responseData);
          return defaultResponseDTO;
        }
      }
      return null;
    } catch (e) {
      // Catch and log any exceptions
      print('Error fetching : $e');
      return null;
    }
  }
  //결제완료
  Future<PayOrderResultDetailDTO?> orderEnd(Map<String, dynamic> requestData) async {
    try {
      final response = await repository.reqPost(url: Constant.apiOrderEndUrl, data: requestData);
      if (response != null) {
        if (response.statusCode == 200) {
          Map<String, dynamic> responseData = response.data;
          PayOrderResultDetailDTO payOrderResultDetailDTO = PayOrderResultDetailDTO.fromJson(responseData);
          return payOrderResultDetailDTO;
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
final paymentViewModelProvider =
StateNotifierProvider<PaymentViewModel, PaymentModel?>((ref) {
  return PaymentViewModel(null, ref);
});