import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moni_pod_web/common/provider/sensing/web_api.dart';
import 'package:moni_pod_web/features/admin_member/data/member_repository.dart';

import 'domain/member_repository_interface.dart';

final memberRepositoryProvider = AutoDisposeProvider<MemberRepositoryInterface>((ref) {
  return MemberRepository(WebApi.instance);
});