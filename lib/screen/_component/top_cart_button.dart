import 'package:BliU/screen/_component/cart_screen.dart';
import 'package:BliU/screen/_component/viewmodel/top_cart_button_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopCartButton extends ConsumerWidget {
  const TopCartButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(topCartButtonViewModelProvider);
        String cartCount = model?.cartCount ?? "0";

        return Stack(
          children: [
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: SvgPicture.asset("assets/images/exhibition/ic_cart.svg"),
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
              right: 8,
              top: 28,
              child: Visibility(
                visible: cartCount == "0" ? false : true,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6191),
                    borderRadius: BorderRadius.circular(6),
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
    );
  }

}