import 'dart:convert';
import 'dart:io';

import 'package:BliU/data/fcm_data.dart';
import 'package:BliU/utils/shared_preferences_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FirebaseService {
  static String? fcmToken; // Variable to store the FCM token
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() => _instance;

  FirebaseService._internal();

  late WidgetRef? ref;
  FcmData? saveFcmData;

  void setRef(WidgetRef ref) {
    this.ref = ref;
  }

  Future<void> initMessage() async {

    final pref = await SharedPreferencesManager.getInstance();

    await fireBaseInitializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initializeNotification();

    if (Platform.isIOS) {
      var token = await FirebaseMessaging.instance.getAPNSToken();
      if (token == null) {
        await Future.delayed(const Duration(seconds: 2), () async {
          token = await FirebaseMessaging.instance.getAPNSToken();
          if (token != null) {
            fcmToken = await FirebaseMessaging.instance.getToken();
          }
        });
      } else {
        fcmToken = await FirebaseMessaging.instance.getToken();
      }
    } else {
      fcmToken = await FirebaseMessaging.instance.getToken();
    }

    if (kDebugMode) {
      print("fcmToken ====> $fcmToken");
    }
    await pref.setToken(fcmToken ?? "");
  }

  Future<void> fireBaseInitializeApp() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Platform.isAndroid ? 'AIzaSyCZyPF0_XZ105BRHpsOmlygeXbUn7XboSA' : 'AIzaSyB0Rcg7ZaT7LUMR4U5igmLQqR6T9HaMoOs',//aos: current_key, ios : API_KEY
          appId: Platform.isAndroid ? '1:997399886578:android:c84ee8a8553d876f4a2e6b' : '1:997399886578:ios:58b1233c97c1e4874a2e6b',//aos: mobilesdk_app_id, ios: GOOGLE_APP_ID
          messagingSenderId: '997399886578',
          projectId: 'bliu-be62b'
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
        android: AndroidInitializationSettings("@mipmap/launcher_icon"),
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
      saveFcmData = FcmData.fromJson(message.data);
    }
  }

  void _handleMessage(String message) {
    var jsonMap = json.decode(message);
    FcmData fcmData = FcmData.fromJson(jsonMap);
    _handleData(fcmData);
  }

  void _handleData(FcmData fcmData) {
    if (kDebugMode) {
      print("_handleData");
    }
    ref?.read(fcmProvider.notifier).getFcm(fcmData);
  }
}

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
      FirebaseService._instance._handleMessage(payload);
    }
  }
}

final fcmProvider = StateNotifierProvider<FcmProvider, FcmData?>((ref){
  return FcmProvider(null, ref);
});

class FcmProvider extends StateNotifier<FcmData?> {
  final Ref ref;
  FcmProvider(super.state, this.ref);

  void getFcm(FcmData? fcmData) {
    state = fcmData;
  }
}