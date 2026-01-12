import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/provider/sensing/building_resp.dart';
import '../building_provider.dart';
import '../domain/unit_model.dart';

part 'building_view_model.g.dart';

@riverpod
class BuildingViewModel extends _$BuildingViewModel {

  @override
  Future<Building> build(String buildingId) async {
    return _fetchData(buildingId);
  }

  Future<Building> _fetchData(String buildingId) async {
    try {
      Building data = await ref.watch(buildingRepositoryProvider).fetchBuilding(buildingId);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData(String buildingId) async {
    state = const AsyncValue.loading();
    try {
      final res = await _fetchData(buildingId);
      state = AsyncData(res);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
