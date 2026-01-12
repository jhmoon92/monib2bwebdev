import '../dio_api_service.dart';
import 'building_resp.dart';

const getBuildingsAPI = "api/v2/mng/buildings";
const getBuildingAPI = "api/v2/mng/building/%{1}";
const getUnitAPI = "api/v2/mng/building/%{1}/unit/%{2}";
const updateUnitAPI = "api/v2/mng/building/%{1}/unit/update/add";
const addBuildingAPI = "api/v2/mng/building/add";
const addUnitAPI = "api/v2/mng/building/%{1}/unit/add";
const deleteBuildingAPI = "api/v2/mng/building/delete/%{1}";
const deleteUnitAPI = "api/v2/mng/building/%{1}/unit/%{2}";


class BuildingClient extends ClientProvider {
  BuildingClient(BaseApi client) : super(client, ApiType.cloudBuilding);

  Future<BuildingList?> getBuildings() async {
    try {
      final response = await client.httpGet(getBuildingsAPI, query: {});

      if (response.statusCode == 200) {
        final resMap = response.data;
        BuildingList result = BuildingList.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<BuildingServer?> getBuilding(String buildingId) async {
    try {
      final apiUrl = strFormat(getBuildingAPI, [buildingId]);
      final response = await client.httpGet(apiUrl, query: {});

      if (response.statusCode == 200) {
        final resMap = response.data;
        BuildingServer result = BuildingServer.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<UnitServer?> getUnit(String buildingId, String unitId) async {
    try {
      final apiUrl = strFormat(getUnitAPI, [buildingId, unitId]);
      final response = await client.httpGet(apiUrl, query: {});

      if (response.statusCode == 200) {
        final resMap = response.data;
        UnitServer result = UnitServer.fromJson(resMap);
        return result;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateUnit(String buildingId, UnitServer unit) async {
    try {
      final apiUrl = strFormat(updateUnitAPI, [buildingId, unit.id.toString()]);

      final response = await client.httpPatch(apiUrl, data: unit.toJson());

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBuilding(BuildingServer building) async {
    try {
      final response = await client.httpPost(addBuildingAPI, data: building.toJson());

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addUnit(String buildingId, UnitServer unit) async {
    try {
      final apiUrl = strFormat(addUnitAPI, [buildingId]);

      final response = await client.httpPost(apiUrl, data: unit.toJson());

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteBuilding(String buildingId) async {
    try {
      final apiUrl = strFormat(deleteBuildingAPI, [buildingId]);

      final response = await client.httpDelete(apiUrl);

      if (response.statusCode == 200) {
        return SUCCESS;
      }
      return FAIL;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteUnit(String buildingId, String unitId) async {
    try {
      final apiUrl = strFormat(deleteUnitAPI, [buildingId,unitId]);

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
