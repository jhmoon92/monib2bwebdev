import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


import '../../common/provider/sensing/web_api.dart';
import 'data/auth_local_data_source.dart';
import 'data/auth_repository.dart';
import 'domain/auth_repository_interface.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepositoryInterface authRepository(AuthRepositoryRef ref) {
  final auth = AuthRepository(AuthLocalDataSource(), WebApi.instance);
  //ref.onDispose(() {auth.dispose();});
  return auth;
}

// final accountInfoFutureProvider = AutoDisposeFutureProvider<AccountEntity>((ref) async {
//   final database = ref.watch(authRepositoryProvider);
//   return await database.getAccountInfo();
// });


// final authRepositoryProvider = Provider<AuthRepository>((ref) {
//   final auth = AuthRepository(SettingRepository.instance);
//   //ref.onDispose(() {auth.dispose();});
//   return auth;
// });

// final userIdChangeProvider = Provider<UserEntity>((ref) {
//   return ref.watch(authRepositoryProvider);
// });
// @riverpod
// int userIdChange(AuthRepositoryRef ref){ return ref.watch(authRepositoryProvider).currentUser();}
//
// final authStateChangeProvider = Provider((ref) {
//   ref.watch(authRepositoryProvider);
//
//   return ref.read(authRepositoryProvider).currentUser();
// });

//final userValueNotifier = ValueNotifier<UserEntity>(defaultUserEntity);


//final appAuthStateListenable = ValueNotifier<AppAuthState>(AppAuthState.init);
//late final AppStateRefresh appState;
/// ValueNotifier for logined  is need.

