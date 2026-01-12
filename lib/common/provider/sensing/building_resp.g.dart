// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingList _$BuildingListFromJson(Map<String, dynamic> json) => BuildingList(
  buildings:
      (json['buildings'] as List<dynamic>)
          .map((e) => BuildingServer.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$BuildingListToJson(BuildingList instance) =>
    <String, dynamic>{'buildings': instance.buildings};

BuildingServer _$BuildingServerFromJson(Map<String, dynamic> json) =>
    BuildingServer(
      id: json['id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      region: json['region'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      managers:
          (json['managers'] as List<dynamic>?)
              ?.map((e) => ManagerServer.fromJson(e as Map<String, dynamic>))
              .toList(),
      units:
          (json['units'] as List<dynamic>?)
              ?.map((e) => UnitServer.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$BuildingServerToJson(BuildingServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'region': instance.region,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'managers': instance.managers,
      'units': instance.units,
    };

ManagerServer _$ManagerServerFromJson(Map<String, dynamic> json) =>
    ManagerServer(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$ManagerServerToJson(ManagerServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
    };

UnitServer _$UnitServerFromJson(Map<String, dynamic> json) => UnitServer(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  lastMotion:
      json['last_motion'] == null
          ? null
          : DateTime.parse(json['last_motion'] as String),
  duration: json['duration'] as String?,
  alert: (json['alert'] as num?)?.toInt(),
  numStations: (json['num_stations'] as num?)?.toInt(),
  vacation: json['vacation'] as bool?,
  residents:
      (json['residents'] as List<dynamic>?)
          ?.map((e) => Resident.fromJson(e as Map<String, dynamic>))
          .toList(),
  installer:
      json['installer'] == null
          ? null
          : Installer.fromJson(json['installer'] as Map<String, dynamic>),
  sensors:
      (json['sensors'] as List<dynamic>?)
          ?.map((e) => SensorGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UnitServerToJson(UnitServer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'last_motion': instance.lastMotion?.toIso8601String(),
      'duration': instance.duration,
      'alert': instance.alert,
      'num_stations': instance.numStations,
      'vacation': instance.vacation,
      'residents': instance.residents,
      'installer': instance.installer,
      'sensors': instance.sensors,
    };

Resident _$ResidentFromJson(Map<String, dynamic> json) => Resident(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  birth: json['birth'] == null ? null : DateTime.parse(json['birth'] as String),
  gender: (json['gender'] as num?)?.toInt(),
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$ResidentToJson(Resident instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'birth': instance.birth?.toIso8601String(),
  'gender': instance.gender,
  'phoneNumber': instance.phoneNumber,
};

Installer _$InstallerFromJson(Map<String, dynamic> json) => Installer(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$InstallerToJson(Installer instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
};

SensorGroup _$SensorGroupFromJson(Map<String, dynamic> json) => SensorGroup(
  latestVersion: json['lastest_version'] as String?,
  sensors:
      (json['sensors'] as List<dynamic>?)
          ?.map((e) => SensorDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SensorGroupToJson(SensorGroup instance) =>
    <String, dynamic>{
      'lastest_version': instance.latestVersion,
      'sensors': instance.sensors,
    };

SensorDetail _$SensorDetailFromJson(Map<String, dynamic> json) => SensorDetail(
  id: (json['id'] as num?)?.toInt(),
  mac: json['mac'] as String?,
  building: json['building'] as String?,
  unit:
      json['unit'] == null
          ? null
          : UnitSummary.fromJson(json['unit'] as Map<String, dynamic>),
  residents:
      (json['residents'] as List<dynamic>?)
          ?.map((e) => Resident.fromJson(e as Map<String, dynamic>))
          .toList(),
  version: json['version'] as String?,
  installer: json['installer'] as String?,
  regDate:
      json['reg_date'] == null
          ? null
          : DateTime.parse(json['reg_date'] as String),
);

Map<String, dynamic> _$SensorDetailToJson(SensorDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mac': instance.mac,
      'building': instance.building,
      'unit': instance.unit,
      'residents': instance.residents,
      'version': instance.version,
      'installer': instance.installer,
      'reg_date': instance.regDate?.toIso8601String(),
    };

UnitSummary _$UnitSummaryFromJson(Map<String, dynamic> json) => UnitSummary(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$UnitSummaryToJson(UnitSummary instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
