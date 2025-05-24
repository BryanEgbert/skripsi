import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_tracker_provider.g.dart';

@riverpod
class ChatTracker extends _$ChatTracker {
  @override
  Future<bool> build() async {
    return Future.value(false);
  }

  void shouldReload() {
    state = const AsyncData(true);
  }

  void reset() {
    state = const AsyncData(false);
  }
}
