import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'last_selected.g.dart';

@riverpod
class LastSelected extends _$LastSelected {
  @override
  Future<int> build() async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();
    int? lastSelectedId = await prefs.getInt("lastSelectedAddress");

    if (lastSelectedId == null) await prefs.setInt("lastSelectedAddress", -1);

    lastSelectedId = await prefs.getInt("lastSelectedAddress");

    return Future.value(lastSelectedId);
  }

  Future<void> set(int index) async {
    final SharedPreferencesAsync prefs = SharedPreferencesAsync();

    await prefs.setInt("lastSelectedAddress", index);

    state = AsyncData(index);
  }
}
