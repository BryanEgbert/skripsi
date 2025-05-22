import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@riverpod
class ThemeState extends _$ThemeState {
  @override
  Future<bool> build() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool('isDarkMode');

    if (isDarkMode == null) return Future.value(false);

    return isDarkMode ? Future.value(true) : Future.value(false);
  }

  Future<void> setMode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? isDarkMode = prefs.getBool('isDarkMode');

    if (isDarkMode == true) {
      await prefs.setBool('isDarkMode', false);
    } else {
      await prefs.setBool('isDarkMode', true);
    }

    final bool? value = prefs.getBool('isDarkMode');

    state = AsyncData(value!);
  }
}
