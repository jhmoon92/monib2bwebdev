import 'package:json_annotation/json_annotation.dart';

part 'member_resp.g.dart';

@JsonSerializable()
class MemberList {
  final List<Member> members;

  MemberList({required this.members});

  factory MemberList.fromJson(Map<String, dynamic> json) =>
      _$MemberListFromJson(json);

  Map<String, dynamic> toJson() => _$MemberListToJson(this);
}

@JsonSerializable()
class Member {
  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final int institution;
  final int authority;
  final List<String> assignedBuildings;
  final String? lastLoginDate;
  final int? status;

  Member({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.institution,
    required this.authority,
    required this.assignedBuildings,
    this.lastLoginDate,
    this.status,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);

  Member copyWith({
    int? id,
    String? name,
    String? email,
    String? phoneNumber,
    int? institution,
    int? authority,
    List<String>? assignedBuildings,
    String? lastLoginDate,
    int? status,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      institution: institution ?? this.institution,
      authority: authority ?? this.authority,
      assignedBuildings: assignedBuildings ?? this.assignedBuildings,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      status: status ?? this.status,
    );
  }

  @override
  String toString() {
    return 'Member(id: $id, name: $name, email: $email, authority: $authority)';
  }
}