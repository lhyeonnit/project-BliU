import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:BliU/utils/firebase_service.dart';
import 'package:BliU/utils/get_x_routes.dart';
import 'package:BliU/utils/navigation_service.dart';
import 'package:BliU/utils/permission_manager.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:BliU/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:uuid/uuid.dart';

// 자동 로그인
Future<MemberInfoResponseDTO?> _authAutoLogin(Map<String, dynamic> requestData) async {
  final repository = DefaultRepository();
  final response = await repository.reqPost(url: Constant.apiAuthAutoLoginUrl, data: requestData);
  try {
    if (response != null) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        MemberInfoResponseDTO memberInfoResponseDTO = MemberInfoResponseDTO.fromJson(responseData);
        return memberInfoResponseDTO;
      }
    }
    return null;
  } catch(e) {
    // Catch and log any exceptions
    if (kDebugMode) {
      print('Error request Api: $e');
    }
    return null;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferencesManager.getInstance();

  usePathUrlStrategy();

  KakaoSdk.init(
      nativeAppKey: '525bbbd40b4de98d500d446c14f28bd4'
  );

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  if (!Utils.getInstance().isWeb()) {
    FirebaseService firebaseService = FirebaseService();
    await firebaseService.initMessage();

    await PermissionManager().requestPermission();
  } else {
    final pref = await SharedPreferencesManager.getInstance();
    final token = pref.getToken() ?? "";
    if (token.isEmpty) {
      final uuid= const Uuid().v4();
      pref.setToken(uuid);
    }
  }

  if (pref.getAutoLogin()) {
    Map<String, dynamic> requestData = {
      'app_token': pref.getToken(),
    };

    final memberInfoResponseDTO = await _authAutoLogin(requestData);
    if (memberInfoResponseDTO != null) {
      if (memberInfoResponseDTO.result == true) {
        if(memberInfoResponseDTO.data != null) {
          final data = memberInfoResponseDTO.data!;
          pref.login(data);
        } else {
          pref.logOut();
        }
      } else {
        pref.logOut();
      }
    } else {
      pref.logOut();
    }
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    FirebaseService firebaseService = FirebaseService();
    firebaseService.setRef(ref);

    return GetMaterialApp(
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
        ),
      ),
      themeMode: ThemeMode.light,
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      initialRoute: '/onboard',
      getPages: GetXRoutes.pages,
    );
  }
}