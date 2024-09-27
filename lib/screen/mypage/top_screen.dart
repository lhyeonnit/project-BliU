import 'package:BliU/screen/mypage/component/top/component/my_info.dart';
import 'package:BliU/screen/mypage/component/top/my_coupon_screen.dart';
import 'package:BliU/screen/mypage/component/top/my_review_screen.dart';
import 'package:BliU/screen/mypage/component/top/order_list_screen.dart';
import 'package:BliU/screen/mypage/component/top/point_screen.dart';
import 'package:BliU/screen/mypage/viewmodel/my_view_model.dart';
import 'package:BliU/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopScreen extends ConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, widget) {
        final model = ref.watch(myModelProvider);

        int myRevieCount = 0;
        int myCouponCount = 0;
        int myPoint = 0;
        if (model != null) {
          if (model.memberInfoResponseDTO?.result == true) {
            myRevieCount = model.memberInfoResponseDTO?.data?.myRevieCount ?? 0;
            myCouponCount =
                model.memberInfoResponseDTO?.data?.myCouponCount ?? 0;
            myPoint = model.memberInfoResponseDTO?.data?.myPoint ?? 0;
          }
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: MyInfo(
                  memberInfoData: model?.memberInfoResponseDTO?.data,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(
                      context, '주문·배송', 'assets/images/my/mypage_ic01.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderListScreen()),
                    );
                  }, ''),
                  _buildIconButton(
                      context, '나의리뷰', 'assets/images/my/mypage_ic02.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyReviewScreen()),
                    );
                  }, '$myRevieCount'),
                  _buildIconButton(
                      context, '쿠폰함', 'assets/images/my/mypage_ic03_1.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyCouponScreen()),
                    );
                  }, '$myCouponCount'),
                  _buildIconButton(
                      context, '포인트', 'assets/images/my/mypage_ic04.svg', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PointScreen()),
                    );
                  }, '$myPoint'),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIconButton(BuildContext context, String label, String icon,
      VoidCallback onPressed, String num) {
    return Column(
      children: [
        IconButton(
          icon: SvgPicture.asset(
            icon,
            width: 40,
            height: 40,
          ),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: Responsive.getFont(context, 16),
            height: 1.2,
          ),
        ),
        Text(
          num,
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
