import 'package:moni_pod_web/features/auth/domain/rememberme_entity.dart';

abstract class AuthRepositoryInterface {
  Future<String?> signIn(String email, String password);
  Future<String?> getToken();
  Future<void> logout();

  AccountEntity get currentAccount;
}
