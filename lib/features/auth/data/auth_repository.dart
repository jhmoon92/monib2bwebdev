import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../common/provider/sensing/account_resp.dart';
import '../../../common/provider/sensing/web_api.dart';
import '../domain/auth_repository_interface.dart';
import '../domain/rememberme_entity.dart';
import 'auth_local_data_source.dart';

class ReadRememberMeException implements Exception {
  ReadRememberMeException([message = "Error : Remember me"]);
}

class SignInException implements Exception {
  SignInException([message = "Error : SignIn"]);
}

class AutoSignInException implements Exception {
  AutoSignInException([message = "Error : Auto SignIn"]);
}

class AuthRepository implements AuthRepositoryInterface {
  final AuthLocalDataSource rememberLocalDataSource;
  final WebApi _client;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this.rememberLocalDataSource, this._client);

  AccountEntity _currentAccount = defaultAccountEntity;

  @override
  AccountEntity get currentAccount => _currentAccount;
  @override
  Future<String?> getToken() async => await _storage.read(key: 'access_token');
  @override
  Future<void> logout() async => await _storage.delete(key: 'access_token');

  @override
  Future<String?> signIn(String id, String pwd) async {
    try {
      UserLogin? data = await _client.accountLogin(id, pwd);
      if (data != null && data.access_token.isNotEmpty) {
        //if (active /*&& _user.remember != active*/) {
        await rememberLocalDataSource.setRememberMe(RememberMe(credential: data.access_token, account: id, active: true));
        await _storage.write(key: 'access_token', value: data.access_token);
        _client.setToken(token: data.access_token, tokenType: data.token_type, accountId: id);
        User? user = await _client.getUserInfo();
        if (user != null) {
          _currentAccount = AccountEntity(email: id, remember: true, id: user.id, token: data.access_token);
        }
        return data.access_token;
      }
      throw SignInException();
    } catch (e) {
      rethrow;
    }
  }

  Future<SignOutModel?> singOut(String email, String pwd) async {
    try {
      SignOutModel? user = await _client.signOut(email, pwd);
      if (user != null) {
        return user;
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  //
  // @override
  // Future<UserListResponse> getAccountList() async {
  //   try {
  //     UserListResponse? data = await _client.getAccountList();
  //     if (data != null) {
  //       print("SUCCESS");
  //       print(data.toString());
  //       return data;
  //     }
  //     throw Error();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
}
