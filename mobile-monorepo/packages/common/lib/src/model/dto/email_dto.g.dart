// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SendAuthCodeRequestImpl _$$SendAuthCodeRequestImplFromJson(
  Map<String, dynamic> json,
) => _$SendAuthCodeRequestImpl(
  email: json['email'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$$SendAuthCodeRequestImplToJson(
  _$SendAuthCodeRequestImpl instance,
) => <String, dynamic>{'email': instance.email, 'type': instance.type};

_$VerifyEmailRequestImpl _$$VerifyEmailRequestImplFromJson(
  Map<String, dynamic> json,
) => _$VerifyEmailRequestImpl(
  email: json['email'] as String,
  code: json['code'] as String,
  type: json['type'] as String,
);

Map<String, dynamic> _$$VerifyEmailRequestImplToJson(
  _$VerifyEmailRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'type': instance.type,
};
