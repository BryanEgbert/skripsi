import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message_tracker_provider.g.dart';

@riverpod
class MessageTracker extends _$MessageTracker {
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

@riverpod
class PetOwnerChatListTracker extends _$PetOwnerChatListTracker {
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
