import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Utils? _instance;
  final SharedPreferences _prefs; // SharedPreferences 객체

  static Future<Utils> getInstance() async {
    if (_instance == null) {
      final prefs = await SharedPreferences.getInstance();
      _instance = Utils._(prefs);
    }

    return _instance!;
  }

  Utils._(SharedPreferences prefs) : _prefs = prefs;

  // 데이터를 저장하는 함수
  Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);  // 데이터 저장
  }

  // 데이터를 로드하는 함수
  String? loadData(String key) {
    final myData = _prefs.getString(key); // 저장된 데이터 로드
    return myData;
  }

  String? getMtIdx() {
    final mtIdx = _prefs.getString('mt_idx'); // 저장된 데이터 로드
    return mtIdx;
  }

  //토큰 가져오기
  String? getToken() {
    final token = _prefs.getString('token'); // 저장된 데이터 로드
    return token;
  }

  // 데이터 삭제하는 함수
  Future<void> deleteData(String key) async {
    await _prefs.remove(key);
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      fontSize: 20,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}