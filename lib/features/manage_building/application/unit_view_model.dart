import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../common/provider/sensing/building_resp.dart';
import '../building_provider.dart';

part 'unit_view_model.g.dart';

@riverpod
class UnitViewModel extends _$UnitViewModel {

  @override
  Future<UnitServer> build(String buildingId, String unitId) async {
    return _fetchData(buildingId,unitId);
  }

  Future<UnitServer> _fetchData(String buildingId, String unitId) async {
    try {
      UnitServer data = await ref.watch(buildingRepositoryProvider).fetchUnit(buildingId,unitId);
      return data;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchData(String buildingId, String unitId) async {
    state = const AsyncValue.loading();
    try {
      final res = await _fetchData(buildingId,unitId);
      state = AsyncData(res);
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}
