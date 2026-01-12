// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberList _$MemberListFromJson(Map<String, dynamic> json) => MemberList(
  members:
      (json['members'] as List<dynamic>)
          .map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MemberListToJson(MemberList instance) =>
    <String, dynamic>{'members': instance.members};

Member _$MemberFromJson(Map<String, dynamic> json) => Member(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  institution: (json['institution'] as num).toInt(),
  authority: (json['authority'] as num).toInt(),
  assignedBuildings:
      (json['assignedBuildings'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
  lastLoginDate: json['lastLoginDate'] as String?,
  status: (json['status'] as num?)?.toInt(),
);

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'institution': instance.institution,
  'authority': instance.authority,
  'assignedBuildings': instance.assignedBuildings,
  'lastLoginDate': instance.lastLoginDate,
  'status': instance.status,
};
