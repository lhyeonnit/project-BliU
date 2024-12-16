import 'package:BliU/screen/cancel/cancel_screen.dart';
import 'package:BliU/screen/coupon_receive/coupon_receive_screen.dart';
import 'package:BliU/screen/delivery/delivery_screen.dart';
import 'package:BliU/screen/exchange_return/exchange_return_screen.dart';
import 'package:BliU/screen/find_id/find_id_screen.dart';
import 'package:BliU/screen/find_id_complete/find_id_complete_screen.dart';
import 'package:BliU/screen/find_password/find_password_screen.dart';
import 'package:BliU/screen/inquiry_service/inquiry_service_screen.dart';
import 'package:BliU/screen/join_agree/join_agree_screen.dart';
import 'package:BliU/screen/join_complete/join_complete_screen.dart';
import 'package:BliU/screen/join_form/join_form_screen.dart';
import 'package:BliU/screen/login/login_screen.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/my_review_edit/my_review_edit_screen.dart';
import 'package:BliU/screen/non_order/non_order_screen.dart';
import 'package:BliU/screen/on_boarding/on_boarding_screen.dart';
import 'package:BliU/screen/order_detail/order_detail_screen.dart';
import 'package:BliU/screen/order_list/order_list_screen.dart';
import 'package:BliU/screen/payment/payment_screen.dart';
import 'package:BliU/screen/payment_complete/payment_complete_screen.dart';
import 'package:BliU/screen/payment_coupon/payment_coupon_screen.dart';
import 'package:BliU/screen/payment_iamport/payment_iamport_screen.dart';
import 'package:BliU/screen/product_detail/product_detail_screen.dart';
import 'package:BliU/screen/product_list/product_list_screen.dart';
import 'package:BliU/screen/product_review_detail/product_review_detail_screen.dart';
import 'package:BliU/screen/recommend_info/recommend_info_screen.dart';
import 'package:BliU/screen/recommend_info_edit/recommend_info_edit_screen.dart';
import 'package:BliU/screen/report/report_screen.dart';
import 'package:BliU/screen/review_write/review_write_screen.dart';
import 'package:BliU/screen/search/search_screen.dart';
import 'package:BliU/screen/setting/setting_screen.dart';
import 'package:BliU/screen/smart_lens/smart_lens_screen.dart';
import 'package:BliU/screen/smart_lens_result/smart_lens_result_screen.dart';
import 'package:BliU/screen/store_detail/store_detail_screen.dart';
import 'package:BliU/screen/terms_detail/terms_detail_screen.dart';
import 'package:get/get.dart';

class GetXRoutes {
  static final pages = [
    GetPage(
      name: "/index",
      page: () => const MainScreen()
    ),
    GetPage(
      name: "/onboard",
      page: () => const OnBoardingScreen(),
    ),
    GetPage(
      name: '/login/:isPay',
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: '/join_agree',
      page: () => const JoinAgreeScreen(),
    ),
    GetPage(
      name: '/join_form',
      page: () => const JoinFormScreen(),
    ),
    GetPage(
      name: '/join_complete',
      page: () => const JoinCompleteScreen(),
    ),
    GetPage(
      name: '/find_id',
      page: () => const FindIdScreen(),
    ),
    GetPage(
      name: '/find_id_complete/:id',
      page: () => const FindIdCompleteScreen(),
    ),
    GetPage(
      name: '/find_password',
      page: () => const FindPasswordScreen(),
    ),





    GetPage(
      name: '/my_review_edit',
      page: () => MyReviewEditScreen(reviewData: Get.arguments,),
    ),

    GetPage(
      name: '/coupon_receive/:pt_idx',
      page: () => const CouponReceiveScreen(),
    ),

    GetPage(
      name: '/exchange_return',
      page: () => ExchangeReturnScreen(
        orderData: Get.arguments["orderData"],
        orderDetailData: Get.arguments["orderDetailData"],
      ),
    ),

    GetPage(
      name: '/delivery',
      page: () => DeliveryScreen(
        odtCode: Get.arguments['odtCode'],
        deliveryType: Get.arguments['deliveryType'],
      ),
    ),

    GetPage(
      name: '/cancel',
      page: () => CancelScreen(
        orderData: Get.arguments["orderData"],
        orderDetailData: Get.arguments["orderDetailData"],),
    ),

    GetPage(
      name: '/inquiry_service',
      page: () => InquiryServiceScreen(
        qnaType: Get.arguments['qnaType'],
        ptIdx: Get.arguments['ptIdx'],
      ),
    ),



    GetPage(
      name: '/non_order',
      page: () => const NonOrderScreen(),
    ),





    GetPage(
      name: '/order_detail',
      page: () => OrderDetailScreen(
        orderData: Get.arguments['orderData'],
        detailList: Get.arguments['detailList'],
      ),
    ),
    GetPage(
      name: '/order_list',
      page: () => OrderListScreen(
        otCode: Get.arguments?['otCode'],
      ),
    ),
    GetPage(
      name: '/payment',
      page: () => PaymentScreen(
        payOrderDetailData: Get.arguments['payOrderDetailData'],
        memberType: Get.arguments['memberType'],
      ),
    ),
    GetPage(
      name: '/payment_complete',
      page: () => PaymentCompleteScreen(
        memberType: Get.arguments['memberType'],
        payType: Get.arguments['payType'],
        payOrderResultDetailData: Get.arguments['payOrderResultDetailData'],
        savedRecipientName: Get.arguments['savedRecipientName'],
        savedRecipientPhone: Get.arguments['savedRecipientPhone'],
        savedAddressRoad: Get.arguments['savedAddressRoad'],
        savedAddressDetail: Get.arguments['savedAddressDetail'],
        savedMemo: Get.arguments['savedMemo'],
      ),
    ),
    GetPage(
      name: '/payment_coupon',
      page: () => PaymentCouponScreen(couponList: Get.arguments['couponList'],),
    ),
    GetPage(
      name: '/payment_iamport',
      page: () => PaymentIamportScreen(
        iamportPayData: Get.arguments,
      ),
    ),
    GetPage(
      name: '/product_detail/:pt_idx',
      page: () => const ProductDetailScreen(),
    ),
    GetPage(
      name: '/product_list',
      page: () => ProductListScreen(
        selectedCategory: Get.arguments['selectedCategory'],
        selectSubCategoryIndex: Get.arguments['selectSubCategoryIndex'],
      ),
    ),
    GetPage(
      name: '/product_review_detail/:rt_idx',
      page: () => const ProductReviewDetailScreen(),
    ),
    GetPage(
      name: '/recommend_info',
      page: () => const RecommendInfoScreen(),
    ),
    GetPage(
      name: '/recommend_info_edit',
      page: () => const RecommendInfoEditScreen(),
    ),
    GetPage(
      name: '/report/:rt_idx',
      page: () => const ReportScreen(),
    ),
    GetPage(
      name: '/review_write',
      page: () => ReviewWriteScreen(orderDetailData: Get.arguments,),
    ),
    GetPage(
      name: '/search',
      page: () => const SearchScreen(),
    ),
    GetPage(
      name: '/setting',
      page: () => const SettingScreen(),
    ),
    GetPage(
      name: '/smart_lens',
      page: () => const SmartLensScreen(),
    ),
    GetPage(
      name: '/smart_lens_result',
      page: () => SmartLensResultScreen(imagePath: Get.arguments),
    ),
    GetPage(
      name: '/store_detail/:st_idx',
      page: () => const StoreDetailScreen(),
    ),
    GetPage(
      name: '/terms_detail/:type',
      page: () => const TermsDetailScreen(),
    ),
  ];
}