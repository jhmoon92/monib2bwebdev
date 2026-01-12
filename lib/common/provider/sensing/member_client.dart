import 'package:moni_pod_web/common/provider/sensing/member_resp.dart';

import '../dio_api_service.dart';
import 'account_resp.dart';

const memberInviteAPI = "api/v2/member/invite";
const getMembersAPI = "api/v2/members";
const patchMemberAPI = "api/v2/member/update/%{1}";
const deleteMemberAPI = "api/v2/member/%{1}";

class MemberClient extends ClientProvider {
  MemberClient(BaseApi client) : super(client, ApiType.cloudMember);

  Future<User?> memberInvite(String email, String nickName, String phoneNumber, int authority) async {
    try {
      final response = await client.httpPost(
        memberInviteAPI,
        data: {
          "email": email,
          "nickname": nickName,
          "phoneNumber": phoneNumber,
          "institutionId": 1,
          "authorities": [authority],
        },
      );

      if (response.statusCode == 200) {
        final resMap = response.data;
        User result = User.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<MemberList?> getMembers() async {
    try {
      final response = await client.httpGet(getMembersAPI);

      if (response.statusCode == 200) {
        final resMap = response.data;
        MemberList result = MemberList.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateMember(Member member) async {
    try {
      final apiUrl = strFormat(patchMemberAPI, [member.id.toString()]);
      final response = await client.httpPatch(apiUrl, data: member.toJson());

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteMember(String memberId) async {
    try {
      final apiUrl = strFormat(deleteMemberAPI, [memberId]);

      final response = await client.httpDelete(apiUrl);

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }
}
