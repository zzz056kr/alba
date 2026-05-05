// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_list_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PageListRequest _$PageListRequestFromJson(Map<String, dynamic> json) {
  return _PageListRequest.fromJson(json);
}

/// @nodoc
mixin _$PageListRequest {
  int? get page => throw _privateConstructorUsedError;
  int? get size => throw _privateConstructorUsedError;
  String? get order => throw _privateConstructorUsedError;
  SortType? get direction => throw _privateConstructorUsedError;
  bool? get formUseYn => throw _privateConstructorUsedError;

  /// Serializes this PageListRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PageListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PageListRequestCopyWith<PageListRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageListRequestCopyWith<$Res> {
  factory $PageListRequestCopyWith(
    PageListRequest value,
    $Res Function(PageListRequest) then,
  ) = _$PageListRequestCopyWithImpl<$Res, PageListRequest>;
  @useResult
  $Res call({
    int? page,
    int? size,
    String? order,
    SortType? direction,
    bool? formUseYn,
  });
}

/// @nodoc
class _$PageListRequestCopyWithImpl<$Res, $Val extends PageListRequest>
    implements $PageListRequestCopyWith<$Res> {
  _$PageListRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PageListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = freezed,
    Object? size = freezed,
    Object? order = freezed,
    Object? direction = freezed,
    Object? formUseYn = freezed,
  }) {
    return _then(
      _value.copyWith(
            page: freezed == page
                ? _value.page
                : page // ignore: cast_nullable_to_non_nullable
                      as int?,
            size: freezed == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int?,
            order: freezed == order
                ? _value.order
                : order // ignore: cast_nullable_to_non_nullable
                      as String?,
            direction: freezed == direction
                ? _value.direction
                : direction // ignore: cast_nullable_to_non_nullable
                      as SortType?,
            formUseYn: freezed == formUseYn
                ? _value.formUseYn
                : formUseYn // ignore: cast_nullable_to_non_nullable
                      as bool?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PageListRequestImplCopyWith<$Res>
    implements $PageListRequestCopyWith<$Res> {
  factory _$$PageListRequestImplCopyWith(
    _$PageListRequestImpl value,
    $Res Function(_$PageListRequestImpl) then,
  ) = __$$PageListRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int? page,
    int? size,
    String? order,
    SortType? direction,
    bool? formUseYn,
  });
}

/// @nodoc
class __$$PageListRequestImplCopyWithImpl<$Res>
    extends _$PageListRequestCopyWithImpl<$Res, _$PageListRequestImpl>
    implements _$$PageListRequestImplCopyWith<$Res> {
  __$$PageListRequestImplCopyWithImpl(
    _$PageListRequestImpl _value,
    $Res Function(_$PageListRequestImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PageListRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? page = freezed,
    Object? size = freezed,
    Object? order = freezed,
    Object? direction = freezed,
    Object? formUseYn = freezed,
  }) {
    return _then(
      _$PageListRequestImpl(
        page: freezed == page
            ? _value.page
            : page // ignore: cast_nullable_to_non_nullable
                  as int?,
        size: freezed == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int?,
        order: freezed == order
            ? _value.order
            : order // ignore: cast_nullable_to_non_nullable
                  as String?,
        direction: freezed == direction
            ? _value.direction
            : direction // ignore: cast_nullable_to_non_nullable
                  as SortType?,
        formUseYn: freezed == formUseYn
            ? _value.formUseYn
            : formUseYn // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(includeIfNull: false)
class _$PageListRequestImpl implements _PageListRequest {
  const _$PageListRequestImpl({
    this.page,
    this.size,
    this.order,
    this.direction,
    this.formUseYn,
  });

  factory _$PageListRequestImpl.fromJson(Map<String, dynamic> json) =>
      _$$PageListRequestImplFromJson(json);

  @override
  final int? page;
  @override
  final int? size;
  @override
  final String? order;
  @override
  final SortType? direction;
  @override
  final bool? formUseYn;

  @override
  String toString() {
    return 'PageListRequest(page: $page, size: $size, order: $order, direction: $direction, formUseYn: $formUseYn)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PageListRequestImpl &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.order, order) || other.order == order) &&
            (identical(other.direction, direction) ||
                other.direction == direction) &&
            (identical(other.formUseYn, formUseYn) ||
                other.formUseYn == formUseYn));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, page, size, order, direction, formUseYn);

  /// Create a copy of PageListRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PageListRequestImplCopyWith<_$PageListRequestImpl> get copyWith =>
      __$$PageListRequestImplCopyWithImpl<_$PageListRequestImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PageListRequestImplToJson(this);
  }
}

abstract class _PageListRequest implements PageListRequest {
  const factory _PageListRequest({
    final int? page,
    final int? size,
    final String? order,
    final SortType? direction,
    final bool? formUseYn,
  }) = _$PageListRequestImpl;

  factory _PageListRequest.fromJson(Map<String, dynamic> json) =
      _$PageListRequestImpl.fromJson;

  @override
  int? get page;
  @override
  int? get size;
  @override
  String? get order;
  @override
  SortType? get direction;
  @override
  bool? get formUseYn;

  /// Create a copy of PageListRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PageListRequestImplCopyWith<_$PageListRequestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
