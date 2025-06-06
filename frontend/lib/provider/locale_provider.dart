import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

@riverpod
class LocaleState extends _$LocaleState {
  @override
  Future<String> build() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? locale = await prefs.getString('locale');

    if (locale == null) return Future.value("en");

    return Future.value(locale);
  }

  Future<void> set(String language) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    await prefs.setString('locale', language);

    final String? value = await prefs.getString('locale');

    state = AsyncData(value!);
  }

  Future<void> setIfNull(String language) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    final String? value = await prefs.getString('locale');

    if (value == null) {
      await prefs.setString('locale', language);
    }

    state = AsyncData(value!);
  }
}
