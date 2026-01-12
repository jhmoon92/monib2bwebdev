import 'package:moni_pod_web/common/provider/sensing/account_resp.dart';

import '../../../common/provider/sensing/member_resp.dart';

abstract class MemberRepositoryInterface {
  Future<User?> memberInvite(String email, String nickName, String phoneNumber, int authority);
  Future<List<Member>> getMembers();
  Future<int> updateMember(Member member);
  Future<int> deleteMember(String memberId);
}
