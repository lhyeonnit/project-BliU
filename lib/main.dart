import 'dart:convert';
import 'dart:io';

import 'package:BliU/api/default_repository.dart';
import 'package:BliU/const/constant.dart';
import 'package:BliU/data/fcm_data.dart';
import 'package:BliU/dto/member_info_response_dto.dart';
import 'package:BliU/screen/common/on_boarding_screen.dart';
import 'package:BliU/utils/navigation_service.dart';
import 'package:BliU/utils/permission_manager.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _fcmToken;
FcmData? _fcmData;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // 세부 내용이 필요한 경우 추가...
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  // 액션 추가... 파라미터는 details.payload 방식으로 전달
  String? payload = details.payload;
  if (payload != null) {
    if (payload.isNotEmpty) {
      _handleMessage(payload);
    }
  }
}

Future<void> fireBaseInitializeApp() async {
  // TODO IOS 작업필요
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: Platform.isAndroid ? 'AIzaSyD29_ZlqFqM-bceJ4lRf5PaFa408K_iX6I' : 'AIzaSyCXi1SzLrAzdpjtZn1CHjoEFfIFrlTmwGw',//aos: current_key, ios : API_KEY
        appId: Platform.isAndroid ? '1:1011786302073:android:0bac3f6a309e4b1663caa8' : '1:1011786302073:ios:ee7c1531b9a201f363caa8',//aos: mobilesdk_app_id, ios: GOOGLE_APP_ID
        messagingSenderId: '1011786302073',
        projectId: 'bliu-c754d'
    ),
  );
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
      'high_importance_channel', 'high_importance_notification',
      importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    ),
    onDidReceiveNotificationResponse: (details) {
      // 액션 추가...
      //print("onDidReceiveNotificationResponse ${details.payload}");
      String? payload = details.payload;
      if (payload != null) {
        if (payload.isNotEmpty) {
          _handleMessage(payload);
        }
      }
    },

    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      FcmData fcmData = FcmData.fromJson(message.data);
      String fcmDataString = json.encode(fcmData.toJson());
      //print("notification data = ${message.data}");

      if (Platform.isAndroid) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'high_importance_notification',
                importance: Importance.max,
              ),
              iOS: DarwinNotificationDetails(),
            ),
            payload: fcmDataString);
      }
    }
  });

  // 백그라운드에서 눌러서 들어올시
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //print("onMessageOpenedApp ${message.data}");
    FcmData fcmData = FcmData.fromJson(message.data);
    _handleData(fcmData);
  });

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
    //print("getInitialMessage ${message.data}");
    _fcmData = FcmData.fromJson(message.data);
  }
}

void _handleMessage(String message) {
  var jsonMap = json.decode(message);
  FcmData fcmData = FcmData.fromJson(jsonMap);
  _handleData(fcmData);
}

void _handleData(FcmData fcmData) {
  var context = NavigationService.navigatorKey.currentContext;
  if (context != null) {
    // TODO 푸시 데이터 전달
    // FcmProvider fcmProvider = context.read<FcmProvider>();
    // fcmProvider.setFcmData(fcmData);
  }
}
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();  // ProviderScope에서 값을 주입하기 전까지 에러를 던지도록 설정
});

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
    print('Error request Api: $e');
    return null;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  KakaoSdk.init(
      nativeAppKey: '525bbbd40b4de98d500d446c14f28bd4'
  );

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await fireBaseInitializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  initializeNotification();

  if (Platform.isIOS) {
    var token = await FirebaseMessaging.instance.getAPNSToken();
    if (token == null) {
      await Future.delayed(const Duration(seconds: 2), () async {
        token = await FirebaseMessaging.instance.getAPNSToken();
        if (token != null) {
          _fcmToken = await FirebaseMessaging.instance.getToken();
        }
      });
    } else {
      _fcmToken = await FirebaseMessaging.instance.getToken();
    }
  } else {
    _fcmToken = await FirebaseMessaging.instance.getToken();
  }

  print("fcmToken ====> $_fcmToken");
  final pref = await SharedPreferencesManager.getInstance();
  await pref.setToken(_fcmToken ?? "");

  await PermissionManager().requestPermission();
  if (pref.getAutoLogin()) {
    Map<String, dynamic> requestData = {
      'app_token': _fcmToken,
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

  // runApp(const ProviderScope(child: MyApp()));
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      // theme: ThemeData(
      //   fontFamily: 'Pretendard'
      // ),
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      home: const OnBoardingScreen(), // OnBoardingScreen을 초기 화면으로 설정
    );
  }
}