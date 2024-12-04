import 'package:BliU/screen/find_id/find_id_screen.dart';
import 'package:BliU/screen/find_id_complete/find_id_complete_screen.dart';
import 'package:BliU/screen/find_password/find_password_screen.dart';
import 'package:BliU/screen/join_agree/join_agree_screen.dart';
import 'package:BliU/screen/join_complete/join_complete_screen.dart';
import 'package:BliU/screen/join_form/join_form_screen.dart';
import 'package:BliU/screen/login/login_screen.dart';
import 'package:BliU/screen/main/main_screen.dart';
import 'package:BliU/screen/on_boarding/on_boarding_screen.dart';
import 'package:BliU/screen/recommend_info/recommend_info_screen.dart';
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
      name: '/login',
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
      name: '/recommend_info',
      page: () => const RecommendInfoScreen(),
    ),

    GetPage(
      name: '/terms_detail/:type',
      page: () => const TermsDetailScreen(),
    ),
  ];
}