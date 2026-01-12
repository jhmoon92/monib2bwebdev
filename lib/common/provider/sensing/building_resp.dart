import 'package:json_annotation/json_annotation.dart';

part 'building_resp.g.dart';

@JsonSerializable()
class BuildingList {
  final List<BuildingServer> buildings;

  BuildingList({required this.buildings});

  factory BuildingList.fromJson(Map<String, dynamic> json) => _$BuildingListFromJson(json);

  Map<String, dynamic> toJson() => _$BuildingListToJson(this);
}

@JsonSerializable()
class BuildingServer {
  String? id;
  String? name;
  String? image;
  String? region;
  String? address;
  double? latitude;
  double? longitude;
  List<ManagerServer>? managers;
  List<UnitServer>? units;

  BuildingServer({this.id, this.name, this.image, this.region, this.address, this.latitude, this.longitude, this.managers, this.units});

  factory BuildingServer.fromJson(Map<String, dynamic> json) => _$BuildingServerFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingServerToJson(this);
}

@JsonSerializable()
class ManagerServer {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  ManagerServer({this.id, this.name, this.email, this.phoneNumber});

  factory ManagerServer.fromJson(Map<String, dynamic> json) => _$ManagerServerFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerServerToJson(this);
}

@JsonSerializable()
class UnitServer {
  int? id;
  String? name;
  @JsonKey(name: 'last_motion')
  DateTime? lastMotion;
  String? duration;
  int? alert;
  @JsonKey(name: 'num_stations')
  int? numStations;
  bool? vacation;
  List<Resident>? residents;
  Installer? installer;
  List<SensorGroup>? sensors;

  UnitServer({
    this.id,
    this.name,
    this.lastMotion,
    this.duration,
    this.alert,
    this.numStations,
    this.vacation,
    this.residents,
    this.installer,
    this.sensors,
  });

  factory UnitServer.fromJson(Map<String, dynamic> json) => _$UnitServerFromJson(json);
  Map<String, dynamic> toJson() => _$UnitServerToJson(this);
}

@JsonSerializable()
class Resident {
  int? id;
  String? name;
  DateTime? birth;
  int? gender;
  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  Resident({this.id, this.name, this.birth, this.gender, this.phoneNumber});

  factory Resident.fromJson(Map<String, dynamic> json) => _$ResidentFromJson(json);
  Map<String, dynamic> toJson() => _$ResidentToJson(this);
}

@JsonSerializable()
class Installer {
  int? id;
  String? name;
  String? email;
  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;

  Installer({this.id, this.name, this.email, this.phoneNumber});

  factory Installer.fromJson(Map<String, dynamic> json) => _$InstallerFromJson(json);
  Map<String, dynamic> toJson() => _$InstallerToJson(this);
}

@JsonSerializable()
class SensorGroup {
  @JsonKey(name: 'lastest_version')
  String? latestVersion;
  List<SensorDetail>? sensors;

  SensorGroup({this.latestVersion, this.sensors});

  factory SensorGroup.fromJson(Map<String, dynamic> json) => _$SensorGroupFromJson(json);
  Map<String, dynamic> toJson() => _$SensorGroupToJson(this);
}

@JsonSerializable()
class SensorDetail {
  int? id;
  String? mac;
  String? building;
  UnitSummary? unit;
  List<Resident>? residents;
  String? version;
  String? installer;
  @JsonKey(name: 'reg_date')
  DateTime? regDate;

  SensorDetail({this.id, this.mac, this.building, this.unit, this.residents, this.version, this.installer, this.regDate});

  factory SensorDetail.fromJson(Map<String, dynamic> json) => _$SensorDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDetailToJson(this);
}

@JsonSerializable()
class UnitSummary {
  int? id;
  String? name;

  UnitSummary({this.id, this.name});

  factory UnitSummary.fromJson(Map<String, dynamic> json) => _$UnitSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$UnitSummaryToJson(this);
}
