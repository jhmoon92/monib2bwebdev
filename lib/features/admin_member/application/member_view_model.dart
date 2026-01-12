import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../domain/member_model.dart';
import '../member_provider.dart';

part 'member_view_model.g.dart';

@riverpod
class MemberViewModel extends _$MemberViewModel {

  @override
  Future<List<Member>> build() async {
    return _fetchData();
  }

  Future<List<Member>> _fetchData() async {
    try {
      List<Member> data = await ref.watch(memberRepositoryProvider).getMembers();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    try {
      final res = await _fetchData();
      state = AsyncData(res);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<int> updateMember(Member member) async {
    try {
      int data = await ref.read(memberRepositoryProvider).updateMember(member);
      return data;
    } catch (e) {
      rethrow;
    }
  }


  Future<int> deleteMember(String memberId) async {
    try {
      int data = await ref.read(memberRepositoryProvider).deleteMember(memberId);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
