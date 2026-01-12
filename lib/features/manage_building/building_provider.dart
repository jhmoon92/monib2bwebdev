import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moni_pod_web/common/provider/sensing/web_api.dart';
import 'package:moni_pod_web/features/manage_building/data/building_repository.dart';

import 'package:moni_pod_web/features/manage_building/data/building_repository_interface.dart';

final buildingRepositoryProvider = AutoDisposeProvider<BuildingRepositoryInterface>((ref) {
  return BuildingRepository(WebApi.instance);
});