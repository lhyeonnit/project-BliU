import 'package:BliU/api/default_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentModel {

}

class PaymentViewModel extends StateNotifier<PaymentModel?> {
  final Ref ref;
  final repository = DefaultRepository();

  PaymentViewModel(super.state, this.ref);




}

// ViewModel Provider 정의
final paymentViewModelProvider =
StateNotifierProvider<PaymentViewModel, PaymentModel?>((ref) {
  return PaymentViewModel(null, ref);
});