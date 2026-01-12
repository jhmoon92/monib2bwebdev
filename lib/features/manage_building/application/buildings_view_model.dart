import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/provider/sensing/building_resp.dart';
import '../domain/unit_model.dart';
import '../building_provider.dart';

part 'buildings_view_model.g.dart';

@riverpod
class BuildingsViewModel extends _$BuildingsViewModel {
  @override
  Future<List<Building>> build() async {
    return _fetchData();
  }

  Future<List<Building>> _fetchData() async {
    try {
      List<Building> data = await ref.watch(buildingRepositoryProvider).fetchBuildings();
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData() async {
    state = const AsyncValue.loading();
    try {
      final res = await _fetchData();
      state = AsyncData(res);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }

  Future<int> updateUnit(String buildingId, UnitServer unit) async {
    try {
      int data = await ref.read(buildingRepositoryProvider).updateUnit(buildingId, unit);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addBuilding(BuildingServer building) async {
    try {
      int data = await ref.read(buildingRepositoryProvider).addBuilding(building);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> addUnit(String buildingId, UnitServer unit) async {
    try {
      int data = await ref.read(buildingRepositoryProvider).addUnit(buildingId, unit);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteBuilding(String buildingId) async {
    try {
      int data = await ref.read(buildingRepositoryProvider).deleteBuilding(buildingId);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteUnit(String buildingId, String unitId) async {
    try {
      int data = await ref.read(buildingRepositoryProvider).deleteUnit(buildingId, unitId);
      return data;
    } catch (e) {
      rethrow;
    }
  }
}
