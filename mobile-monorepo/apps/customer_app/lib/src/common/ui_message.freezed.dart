// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ui_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$UiMessage {
  UiMessageKind get kind => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  /// Create a copy of UiMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UiMessageCopyWith<UiMessage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UiMessageCopyWith<$Res> {
  factory $UiMessageCopyWith(UiMessage value, $Res Function(UiMessage) then) =
      _$UiMessageCopyWithImpl<$Res, UiMessage>;
  @useResult
  $Res call({UiMessageKind kind, String text});
}

/// @nodoc
class _$UiMessageCopyWithImpl<$Res, $Val extends UiMessage>
    implements $UiMessageCopyWith<$Res> {
  _$UiMessageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UiMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? kind = null, Object? text = null}) {
    return _then(
      _value.copyWith(
            kind: null == kind
                ? _value.kind
                : kind // ignore: cast_nullable_to_non_nullable
                      as UiMessageKind,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UiMessageImplCopyWith<$Res>
    implements $UiMessageCopyWith<$Res> {
  factory _$$UiMessageImplCopyWith(
    _$UiMessageImpl value,
    $Res Function(_$UiMessageImpl) then,
  ) = __$$UiMessageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({UiMessageKind kind, String text});
}

/// @nodoc
class __$$UiMessageImplCopyWithImpl<$Res>
    extends _$UiMessageCopyWithImpl<$Res, _$UiMessageImpl>
    implements _$$UiMessageImplCopyWith<$Res> {
  __$$UiMessageImplCopyWithImpl(
    _$UiMessageImpl _value,
    $Res Function(_$UiMessageImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of UiMessage
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? kind = null, Object? text = null}) {
    return _then(
      _$UiMessageImpl(
        kind: null == kind
            ? _value.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as UiMessageKind,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UiMessageImpl implements _UiMessage {
  const _$UiMessageImpl({required this.kind, required this.text});

  @override
  final UiMessageKind kind;
  @override
  final String text;

  @override
  String toString() {
    return 'UiMessage(kind: $kind, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UiMessageImpl &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, kind, text);

  /// Create a copy of UiMessage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UiMessageImplCopyWith<_$UiMessageImpl> get copyWith =>
      __$$UiMessageImplCopyWithImpl<_$UiMessageImpl>(this, _$identity);
}

abstract class _UiMessage implements UiMessage {
  const factory _UiMessage({
    required final UiMessageKind kind,
    required final String text,
  }) = _$UiMessageImpl;

  @override
  UiMessageKind get kind;
  @override
  String get text;

  /// Create a copy of UiMessage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UiMessageImplCopyWith<_$UiMessageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
