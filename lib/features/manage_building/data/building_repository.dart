import 'package:moni_pod_web/features/manage_building/application/buildings_view_model.dart';

import '../../../common/provider/dio_api_service.dart';
import '../../../common/provider/sensing/building_resp.dart';
import '../../../common/provider/sensing/web_api.dart';
import '../domain/unit_model.dart';
import 'building_repository_interface.dart';

class BuildingRepository implements BuildingRepositoryInterface {
  final WebApi _client;

  BuildingRepository(this._client);

  @override
  Future<List<Building>> fetchBuildings() async {
    try {
      BuildingList? tem = await _client.getBuildings();
      if (tem != null) {
        List<BuildingServer> buildings = tem.buildings;
        List<Building> data = [];

        for (var building in buildings) {
          data.add(
            Building(
              id: building.id.toString(),
              name: building.name ?? '',
              address: building.address ?? '',
              totalUnit: building.units?.length ?? 0,
              activeUnit: building.units?.where((u) => u.alert != 3).length ?? 0,
              criticalUnit: building.units?.where((u) => u.alert == 1).length ?? 0,
              warningUnit: building.units?.where((u) => u.alert == 2).length ?? 0,
              managerList: building.managers ?? [],
              unitList: building.units ?? [],
            ),
          );
        }
        return data;
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Building> fetchBuilding(String buildingId) async {
    try {
      BuildingServer? building = await _client.getBuilding(buildingId);

      if (building == null) {
        throw Exception();
      } else {
        return Building(
          id: building.id.toString(),
          name: building.name ?? '',
          address: building.address ?? '',
          totalUnit: building.units?.length ?? 0,
          activeUnit: building.units?.where((u) => u.alert != 3).length ?? 0,
          criticalUnit: building.units?.where((u) => u.alert == 1).length ?? 0,
          warningUnit: building.units?.where((u) => u.alert == 2).length ?? 0,
          managerList: building.managers ?? [],
          unitList: building.units ?? [],
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UnitServer> fetchUnit(String buildingId, String unitId) async {
    try {
      UnitServer? data = await _client.getUnit(buildingId, unitId);
      if (data == null) {
        throw Exception();
      } else {
        return data;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> updateUnit(String buildingId, UnitServer unit) async {
    try {
      int response = await _client.addUnit(buildingId, unit);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> addBuilding(BuildingServer building) async {
    try {
      int response = await _client.addBuilding(building);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> addUnit(String buildingId, UnitServer unit) async {
    try {
      int response = await _client.addUnit(buildingId, unit);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> deleteBuilding(String buildingId) async {
    try {
      int response = await _client.deleteBuilding(buildingId);

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> deleteUnit(String buildingId, String unitId) async {
    try {
      int response = await _client.deleteUnit(buildingId, unitId);

      return response;
    } catch (e) {
      rethrow;
    }
  }
}


