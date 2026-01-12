import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const int DEFAULT_TIMEOUT_SECONDS = 15;
const int FAIL = -1;
const int SUCCESS = 0;

enum ApiType {
  cloudAuth,
  cloudMember,
  cloudBuilding,
  cloudCommon,
  cloudAll,
}

abstract class ClientProvider {
  final BaseApi client;
  final dynamic type;
  ClientProvider(this.client, this.type);
}

class BaseApi {
  final String serverUrl;
  late Dio dio;
  final _storage = const FlutterSecureStorage();

  BaseApi(this.serverUrl) {
    dio = Dio(BaseOptions(
      baseUrl: serverUrl.startsWith('http') ? serverUrl : 'http://$serverUrl/',
      // baseUrl: serverUrl.startsWith('http') ? serverUrl : 'https://$serverUrl',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> httpGet(String url, {Map<String, dynamic>? query}) async {
    return await dio.get(url, queryParameters: query);
  }

  Future<Response> httpPost(String url, {dynamic data}) async {
    return await dio.post(url, data: data);
  }

  Future<Response> httpPatch(String url, {dynamic data}) async {
    return await dio.patch(url, data: data);
  }

  Future<Response> httpDelete(String url, {dynamic data}) async {
    return await dio.delete(url, data: data);
  }
}

String strFormat(String string, List<String> params) {
  String result = string;
  for (int i = 0; i < params.length; i++) {
    result = result.replaceAll('%{${i + 1}}', params[i]);
  }
  return result;
}