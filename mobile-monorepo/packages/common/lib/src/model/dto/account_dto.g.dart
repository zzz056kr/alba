// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestImpl _$$LoginRequestImplFromJson(Map<String, dynamic> json) =>
    _$LoginRequestImpl(
      id: json['id'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$$LoginRequestImplToJson(_$LoginRequestImpl instance) =>
    <String, dynamic>{'id': instance.id, 'password': instance.password};

_$JoinRequestImpl _$$JoinRequestImplFromJson(Map<String, dynamic> json) =>
    _$JoinRequestImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$$JoinRequestImplToJson(_$JoinRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'password': instance.password,
      'email': instance.email,
    };

_$ResetPasswordRequestImpl _$$ResetPasswordRequestImplFromJson(
  Map<String, dynamic> json,
) => _$ResetPasswordRequestImpl(
  email: json['email'] as String,
  code: json['code'] as String,
  newPassword: json['newPassword'] as String,
);

Map<String, dynamic> _$$ResetPasswordRequestImplToJson(
  _$ResetPasswordRequestImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'code': instance.code,
  'newPassword': instance.newPassword,
};
