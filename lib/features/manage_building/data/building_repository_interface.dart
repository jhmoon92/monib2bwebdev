import '../../../common/provider/sensing/building_resp.dart';
import '../domain/unit_model.dart';

abstract class BuildingRepositoryInterface {
  Future<List<Building>> fetchBuildings();
  Future<Building> fetchBuilding(String buildingId);
  Future<UnitServer> fetchUnit(String buildingId, String unitId);
  Future<int> updateUnit(String buildingId, UnitServer unit);
  Future<int> addBuilding(BuildingServer building);
  Future<int> addUnit(String buildingId, UnitServer unit);
  Future<int> deleteBuilding(String buildingId);
  Future<int> deleteUnit(String buildingId, String unitId);
}
