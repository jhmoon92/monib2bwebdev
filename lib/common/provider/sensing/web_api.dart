import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moni_pod_web/common/provider/sensing/building_client.dart';
import 'package:moni_pod_web/common/provider/sensing/member_client.dart';
import 'package:moni_pod_web/common/provider/sensing/member_resp.dart';
import 'package:moni_pod_web/features/manage_building/domain/unit_model.dart';

import '../../../features/setting/data/app_config_repository.dart';
import '../dio_api_service.dart';
import 'account_resp.dart';
import 'auth_client.dart';
import 'building_resp.dart';

final webApiProvider = Provider<WebApi>((ref) {
  return WebApi.instance;
});

class WebApi {
  final Map<int, ClientProvider> _apis = {};
  Map<int, ClientProvider> get apis => _apis;

  // Dio를 사용하는 BaseApi는 싱글톤 패턴에 적합합니다.
  late final BaseApi client;

  static final WebApi instance = WebApi._internal();

  void setApi(ApiType type, ClientProvider api) => _apis[type.index] = api;

  WebApi._internal() {
    client = BaseApi(AppConfigRepository.instance.serverUrl);
    setApi(ApiType.cloudAuth, AuthClient(client));
    setApi(ApiType.cloudMember, MemberClient(client));
    setApi(ApiType.cloudBuilding, BuildingClient(client));
  }

  // [수정] 더 이상 BaseApi를 새로 생성할 필요가 없습니다.
  // 인터셉터가 FlutterSecureStorage에서 토큰을 알아서 꺼내 쓰기 때문입니다.
  void setToken({String? token, String? tokenType, String? accountId}) {
    // 이제 이 함수는 아무것도 하지 않거나,
    // 필요한 경우 스토리지에 토큰을 저장하는 로직만 트리거하면 됩니다.
    debugPrint("Token management is handled by Dio Interceptor.");
  }

  Future<UserLogin?> accountLogin(String username, String password) async {
    AuthClient api = _apis[ApiType.cloudAuth.index] as AuthClient;
    return await api.userLogin(username, password);
  }

  Future<User?> getUserInfo() async {
    AuthClient api = _apis[ApiType.cloudAuth.index] as AuthClient;
    return await api.getUserInfo();
  }

  Future<SignOutModel?> signOut(String email, String password) async {
    AuthClient api = _apis[ApiType.cloudAuth.index] as AuthClient;
    return await api.signOut(email, password);
  }

  Future<User?> memberInvite(String email, String nickName, String phoneNumber, int authority) async {
    MemberClient api = _apis[ApiType.cloudMember.index] as MemberClient;
    return await api.memberInvite(email, nickName, phoneNumber, authority);
  }

  Future<MemberList?> getMembers() async {
    MemberClient api = _apis[ApiType.cloudMember.index] as MemberClient;
    return await api.getMembers();
  }

  Future<int> updateMember(Member member) async {
    MemberClient api = _apis[ApiType.cloudMember.index] as MemberClient;
    return await api.updateMember(member);
  }

  Future<int> deleteMember(String memberId) async {
    MemberClient api = _apis[ApiType.cloudMember.index] as MemberClient;
    return await api.deleteMember(memberId);
  }

  Future<BuildingList?> getBuildings() async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.getBuildings();
  }

  Future<BuildingServer?> getBuilding(String buildingId) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.getBuilding(buildingId);
  }

  Future<UnitServer?> getUnit(String buildingId, String unitId) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.getUnit(buildingId, unitId);
  }

  Future<int> addBuilding(BuildingServer building) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.addBuilding(building);
  }

  Future<int> updateUnit(String buildingId, UnitServer unit) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.addUnit(buildingId, unit);
  }

  Future<int> addUnit(String buildingId, UnitServer unit) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.addUnit(buildingId, unit);
  }

  Future<int> deleteBuilding(String buildingId) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.deleteBuilding(buildingId);
  }

  Future<int> deleteUnit(String buildingId, String unitId) async {
    BuildingClient api = _apis[ApiType.cloudBuilding.index] as BuildingClient;
    return await api.deleteUnit(buildingId, unitId);
  }
}
