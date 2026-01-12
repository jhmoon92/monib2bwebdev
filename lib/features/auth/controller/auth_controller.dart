import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/provider/dio_api_service.dart';
import '../../../common/provider/sensing/auth_client.dart';
import '../../../common/provider/sensing/web_api.dart';
import '../auth_provider.dart';

final authControllerProvider = AsyncNotifierProvider<AuthController, String?>(() {
  return AuthController();
});

class AuthController extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    final repository = ref.read(authRepositoryProvider);
    final sensingApi = ref.read(webApiProvider);

    // 1. 저장된 토큰 읽기
    final token = await repository.getToken();

    if (token != null && token.isNotEmpty) {
      try {
        // 2. 토큰 유효성 검사 (getUserInfo 호출)
        // SensingApi에 등록된 cloudAuth 클라이언트를 가져옵니다.
        final authClient = sensingApi.apis[ApiType.cloudAuth.index] as AuthClient;
        final user = await authClient.getUserInfo();

        if (user != null) {
          // 성공 시 토큰 유지 -> Router가 home으로 이동시킴
          return token;
        }
      } catch (e) {
        // 토큰이 만료되었거나 서버 에러 시 세션 초기화
        await repository.logout();
      }
    }
    return null; // 로그인 페이지로 유지
  }

  // 기존 signIn 메서드는 유지
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final token = await ref.read(authRepositoryProvider).signIn(email, password);
      return token;
    });
  }

  // Future<void> logout() async {
  //   await ref.read(authRepositoryProvider).logout();
  //   state = const AsyncValue.data(null);
  // }
}
