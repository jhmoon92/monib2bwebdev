import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../dio_api_service.dart';
import 'account_resp.dart';

const userAuthLoginAPI = "api/v2/auth/sign-in";
const userSignOutAPI = "api/v2/auth/sign-out";
const userInfoAPI = "api/v2/token";
const memberInviteAPI = "api/v2/member/invite";

class AuthClient extends ClientProvider {
  AuthClient(BaseApi client) : super(client, ApiType.cloudAuth);

  Future<UserLogin?> userLogin(String email, String password) async {
    try {
      final response = await client.httpPost(userAuthLoginAPI, data: {
        "email": email,
        "password": password,
        "rememberMe": true,
      });

      if (response.statusCode == 200) {
        final resMap = response.data;
        UserLogin result = UserLogin.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUserInfo() async {
    try {
      final response = await client.httpGet(userInfoAPI);
      if (response.statusCode == 200) {
        final resMap = response.data;
        User result = User.fromJson(resMap);
        return result;
      } else {
        return null;
      }
    } on DioException catch (e) {
      debugPrint("getUserInfo DioError: ${e.message}");
      rethrow;
    } catch (e) {
      debugPrint("getUserInfo GeneralError: $e");
      rethrow;
    }
  }

  Future<SignOutModel?> signOut(String email, String password) async {
    try {
      final response = await client.httpPost(userSignOutAPI, data: {
        "email": email,
        "password": password,
        "rememberMe": true,
      });

      if (response.statusCode == 200) {
        final resMap = response.data;
        SignOutModel result = SignOutModel.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

}
