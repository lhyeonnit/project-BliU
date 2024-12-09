import 'dart:convert';

import 'package:BliU/data/member_info_data.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager? _instance;
  final SharedPreferences _prefs;

  static Future<SharedPreferencesManager> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = SharedPreferencesManager._(prefs);
    }
    return _instance!;
  }

  SharedPreferencesManager._(SharedPreferences prefs) : _prefs = prefs;

  bool getAppFirst() {
    return _prefs.getBool('app_first') ?? true;
  }

  Future<void> setAppFirst() async {
    await _prefs.setBool("app_first", false);
  }

  // mtId를 불러오는 함수
  String? getMtId() {
    return _prefs.getString('mt_id');
  }

  // mtIdx를 불러오는 함수
  String? getMtIdx() {
    return _prefs.getString('mt_idx');
  }

  Future<void> setAutoLogin(bool autoLogin) async {
    await _prefs.setBool("auto_login", autoLogin);
  }

  bool getAutoLogin() {
    return _prefs.getBool('auto_login') ?? false;
  }

  // 토큰을 저장하는 함수
  Future<void> setToken(String value) async {
    await _prefs.setString('token', value);
  }

  // 토큰을 불러오는 함수
  String? getToken() {
    return _prefs.getString('token');
  }

  // 데이터 삭제하는 함수
  Future<void> deleteData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> login(MemberInfoData data) async {
    await _prefs.setString('mt_id', (data.mtId ?? ""));
    await _prefs.setString('mt_idx', (data.mtIdx ?? "").toString());
    await _prefs.setString('member_info', jsonEncode(data.toJson()));
  }

  MemberInfoData? getMemberInfo() {
    MemberInfoData? memberInfoData;
    final memberInfoJsonString = _prefs.getString('member_info') ?? "";
    try {
      if (memberInfoJsonString.isNotEmpty) {
        Map<String,dynamic> memberInfoJsonData = jsonDecode(memberInfoJsonString);
        memberInfoData = MemberInfoData.fromJson(memberInfoJsonData);
      }
    } catch (e) {
      if (kDebugMode) {
        print("getMemberInfo error $e");
      }
    }

    return memberInfoData;
  }

  //사용자 데이터 삭제 & 로그아웃 - 추후 데이터 추가될경우 항목추가 할것
  Future<void> logOut() async {
    await _prefs.remove("mt_idx");
    await _prefs.remove("mt_id");
    await _prefs.remove("member_info");
    setAutoLogin(false);
  }

  void savePasswordToken(String token) async {
    SharedPreferencesManager prefs = await SharedPreferencesManager.getInstance();
    await prefs._prefs.setString('pwd_token', token);  // 토큰을 SharedPreferences에 저장
  }

  Future<String?> getPasswordToken() async {
    SharedPreferencesManager prefs = await SharedPreferencesManager.getInstance();
    return prefs._prefs.getString('pwd_token');  // 저장된 pwd_token 불러오기
  }
}
