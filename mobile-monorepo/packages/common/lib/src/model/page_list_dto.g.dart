// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PageListRequestImpl _$$PageListRequestImplFromJson(
  Map<String, dynamic> json,
) => _$PageListRequestImpl(
  page: (json['page'] as num?)?.toInt(),
  size: (json['size'] as num?)?.toInt(),
  order: json['order'] as String?,
  direction: $enumDecodeNullable(_$SortTypeEnumMap, json['direction']),
  formUseYn: json['formUseYn'] as bool?,
);

Map<String, dynamic> _$$PageListRequestImplToJson(
  _$PageListRequestImpl instance,
) => <String, dynamic>{
  if (instance.page case final value?) 'page': value,
  if (instance.size case final value?) 'size': value,
  if (instance.order case final value?) 'order': value,
  if (_$SortTypeEnumMap[instance.direction] case final value?)
    'direction': value,
  if (instance.formUseYn case final value?) 'formUseYn': value,
};

const _$SortTypeEnumMap = {SortType.asc: 'ASC', SortType.desc: 'DESC'};
