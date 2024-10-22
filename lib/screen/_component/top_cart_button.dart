import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/viewmodel/top_cart_button_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:focus_detector_v2/focus_detector_v2.dart';

class TopCartButton extends ConsumerWidget {

  const TopCartButton({super.key});

  void _viewWillAppear(BuildContext context, WidgetRef ref) {
    SharedPreferencesManager.getInstance().then((pref) {
      final mtIdx = pref.getMtIdx() ?? "";
      int type = 1;
      if (mtIdx.isEmpty) {
        type = 2;
      }

      Map<String, dynamic> requestData = {
        'type': type,
        'mt_idx': mtIdx,
        'temp_mt_id': pref.getToken(),
      };

      ref.read(topCartButtonViewModelProvider.notifier).getCartCount(requestData);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(cartProvider,
      ((previous, next) {
        if (next == true) {
          ref.read(cartProvider.notifier).cartRefresh(false);
          _viewWillAppear(context, ref);
        }
      }),
    );

    return FocusDetector(
      onFocusGained: () {
        _viewWillAppear(context, ref);
      },
      child: Consumer(
        builder: (context, ref, widget) {
          final model = ref.watch(topCartButtonViewModelProvider);
          String cartCount = model?.cartCount ?? "0";

          return Stack(
            children: [
              IconButton(
                padding: const EdgeInsets.only(right: 16, left: 10),
                icon: SvgPicture.asset("assets/images/product/ic_cart.svg",
                  height: Responsive.getHeight(context, 30),
                  width: Responsive.getWidth(context, 30),
                ),
                onPressed: () {
                  // 장바구니 버튼 동작
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 23,
                child: Visibility(
                  visible: cartCount == "0" ? false : true,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6191),
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: Responsive.getWidth(context, 15),
                      minHeight: Responsive.getHeight(context, 14),
                    ),
                    child: Text(
                      cartCount,
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                        fontSize: Responsive.getFont(context, 9),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

final cartProvider = StateNotifierProvider<CartProvider, bool?>((ref){
  return CartProvider(null, ref);
});

class CartProvider extends StateNotifier<bool?> {
  final Ref ref;
  CartProvider(super.state, this.ref);

  void cartRefresh(bool isRefresh){
    state = isRefresh;
  }
}