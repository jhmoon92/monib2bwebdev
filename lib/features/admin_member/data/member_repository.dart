import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/provider/sensing/account_resp.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../../../common/provider/sensing/web_api.dart';
import '../domain/member_model.dart';
import '../domain/member_repository_interface.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  final webApi = ref.watch(webApiProvider);
  return MemberRepository(webApi);
});

class MemberRepository implements MemberRepositoryInterface {
  final WebApi _client;

  MemberRepository(this._client);

  @override
  Future<User?> memberInvite(String email, String nickName, String phoneNumber, int authority) async {
    try {
      User? user = await _client.memberInvite(email, nickName, phoneNumber, authority);
      if (user != null) {
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  @override
  Future<List<Member>> getMembers() async {
    try {
      MemberList? tem = await _client.getMembers();
      if (tem != null) {
        // List<Member> members = tem.members;
        // List<MemberCardData> data = [];
        //
        // for (var member in members) {
        //   data.add(
        //     MemberCardData(
        //       id: member.id,
        //       name: member.name,
        //       role:
        //           member.authority == 1
        //               ? 'Master'
        //               : member.authority == 20
        //               ? 'Manager'
        //               : member.authority == 50
        //               ? 'Installer'
        //               : 'Resident',
        //       status: member.status ?? 0,
        //       email: member.email,
        //       phoneNumber: member.phoneNumber ?? '',
        //       assignedRegion: member.assignedTo ?? [],
        //       lastLoginDate: member.lastLoginDate ?? ''
        //     ),
        //   );
        // }

        return tem.members;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateMember(Member member) async {
    try {
      int response = await _client.updateMember(member);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> deleteMember(String memberId) async {
    try {
      int response = await _client.deleteMember(memberId);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
