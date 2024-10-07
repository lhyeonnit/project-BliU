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

  // 데이터를 저장하는 함수
  Future<void> saveData(String key, String value) async {
    await _prefs.setString(key, value);
  }

  // 데이터를 로드하는 함수
  String? loadData(String key) {
    return _prefs.getString(key);
  }

  // 회원별로 mtId를 저장하는 함수
  Future<void> setMtId(String mtId) async {
    await _prefs.setString('mt_id', mtId);
  }

  // mtId를 불러오는 함수
  String? getMtId() {
    return _prefs.getString('mt_id');
  }

  // 회원별로 mtIdx를 저장하는 함수
  Future<void> setMtIdx(String mtIdx) async {
    await _prefs.setString('mt_idx', mtIdx);
  }

  // mtIdx를 불러오는 함수
  String? getMtIdx() {
    return _prefs.getString('mt_idx');
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

  // 전체 데이터 삭제 함수 (회원 로그아웃 시 사용 가능)
  Future<void> clearAll() async {
    await _prefs.clear();
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
