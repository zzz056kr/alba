import 'package:freezed_annotation/freezed_annotation.dart';

part 'ui_message.freezed.dart';

enum UiMessageKind { info, success, error }

@freezed
class UiMessage with _$UiMessage {
  const factory UiMessage({required UiMessageKind kind, required String text}) =
      _UiMessage;
}
