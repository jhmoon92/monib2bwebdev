import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'account_resp.g.dart';

// --------------------------------------------------------------- //
@JsonSerializable()
class UserLogin {
  String token_type;
  String access_token;
  int expires_in;

  UserLogin(this.token_type, this.access_token, this.expires_in);

  factory UserLogin.fromJson(Map<String, dynamic> json) => _$UserLoginFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginToJson(this);
}

class User {
  final int id;
  final String email;
  final String nickname;
  final String phoneNumber;
  final String institution;
  final String authority;
  final String lastLoginDate;
  final String createdAt;
  final bool accountDeleted;
  final bool accountLock;
  final bool accountExpired;
  final bool needChangePW;
  final String memo;
  final List<MenuModel> menuList;
  final List<int> resourceList;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    required this.phoneNumber,
    required this.institution,
    required this.authority,
    required this.lastLoginDate,
    required this.createdAt,
    required this.accountDeleted,
    required this.accountLock,
    required this.accountExpired,
    required this.needChangePW,
    required this.memo,
    required this.menuList,
    required this.resourceList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      nickname: json['nickname'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      institution: json['institution'] ?? '',
      authority: json['authority'] ?? '',
      lastLoginDate: json['lastLoginDate'] ?? '',
      createdAt: json['createdAt'] ?? '',
      accountDeleted: json['accountDeleted'] ?? false,
      accountLock: json['accountLock'] ?? false,
      accountExpired: json['accountExpired'] ?? false,
      needChangePW: json['needChangePW'] ?? false,
      memo: json['memo'] ?? '',
      menuList: (json['menuList'] as List?)
          ?.map((e) => MenuModel.fromJson(e))
          .toList() ?? [],
      resourceList: List<int>.from(json['resourceList'] ?? []),
    );
  }
}

class MenuModel {
  final int id;
  final String menuName;
  final String url;
  final int orderNum;
  final bool authorized;
  final bool useYn;
  final String icon;
  final String activeIcon;

  MenuModel({
    required this.id,
    required this.menuName,
    required this.url,
    required this.orderNum,
    required this.authorized,
    required this.useYn,
    required this.icon,
    required this.activeIcon,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'] ?? 0,
      menuName: json['menuName'] ?? '',
      url: json['url'] ?? '',
      orderNum: json['orderNum'] ?? 0,
      authorized: json['authorized'] ?? false,
      useYn: json['useYn'] ?? false,
      icon: json['icon'] ?? '',
      activeIcon: json['activeIcon'] ?? '',
    );
  }
}

class SignOutModel {
  final String? message;
  final int? status;
  final List<ErrorDetail>? errors;
  final String? code;

  SignOutModel({
    this.message,
    this.status,
    this.errors,
    this.code,
  });

  // JSON 데이터를 객체로 변환
  factory SignOutModel.fromJson(Map<String, dynamic> json) {
    return SignOutModel(
      message: json['message'] as String?,
      status: json['status'] as int?,
      errors: (json['errors'] as List<dynamic>?)
          ?.map((e) => ErrorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      code: json['code'] as String?,
    );
  }

  // 객체를 JSON 데이터로 변환
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'status': status,
      'errors': errors?.map((e) => e.toJson()).toList(),
      'code': code,
    };
  }
}

class ErrorDetail {
  final String? field;
  final String? value;
  final String? reason;

  ErrorDetail({
    this.field,
    this.value,
    this.reason,
  });

  factory ErrorDetail.fromJson(Map<String, dynamic> json) {
    return ErrorDetail(
      field: json['field'] as String?,
      value: json['value'] as String?,
      reason: json['reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'value': value,
      'reason': reason,
    };
  }
}