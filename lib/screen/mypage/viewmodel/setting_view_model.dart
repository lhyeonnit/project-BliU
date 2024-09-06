import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingModel {

}

class SettingViewModel extends StateNotifier<SettingModel?> {
  SettingViewModel(super.state);


}

final settingModelProvider =
StateNotifierProvider<SettingViewModel, SettingModel?>((_) {
  return SettingViewModel(null);
});