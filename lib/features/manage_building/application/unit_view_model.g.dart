// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$unitViewModelHash() => r'c958c32ff6047f0312847a94a37fcb07ff0d270d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$UnitViewModel
    extends BuildlessAutoDisposeAsyncNotifier<UnitServer> {
  late final String buildingId;
  late final String unitId;

  FutureOr<UnitServer> build(String buildingId, String unitId);
}

/// See also [UnitViewModel].
@ProviderFor(UnitViewModel)
const unitViewModelProvider = UnitViewModelFamily();

/// See also [UnitViewModel].
class UnitViewModelFamily extends Family<AsyncValue<UnitServer>> {
  /// See also [UnitViewModel].
  const UnitViewModelFamily();

  /// See also [UnitViewModel].
  UnitViewModelProvider call(String buildingId, String unitId) {
    return UnitViewModelProvider(buildingId, unitId);
  }

  @override
  UnitViewModelProvider getProviderOverride(
    covariant UnitViewModelProvider provider,
  ) {
    return call(provider.buildingId, provider.unitId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'unitViewModelProvider';
}

/// See also [UnitViewModel].
class UnitViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<UnitViewModel, UnitServer> {
  /// See also [UnitViewModel].
  UnitViewModelProvider(String buildingId, String unitId)
    : this._internal(
        () =>
            UnitViewModel()
              ..buildingId = buildingId
              ..unitId = unitId,
        from: unitViewModelProvider,
        name: r'unitViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$unitViewModelHash,
        dependencies: UnitViewModelFamily._dependencies,
        allTransitiveDependencies:
            UnitViewModelFamily._allTransitiveDependencies,
        buildingId: buildingId,
        unitId: unitId,
      );

  UnitViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.buildingId,
    required this.unitId,
  }) : super.internal();

  final String buildingId;
  final String unitId;

  @override
  FutureOr<UnitServer> runNotifierBuild(covariant UnitViewModel notifier) {
    return notifier.build(buildingId, unitId);
  }

  @override
  Override overrideWith(UnitViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: UnitViewModelProvider._internal(
        () =>
            create()
              ..buildingId = buildingId
              ..unitId = unitId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        buildingId: buildingId,
        unitId: unitId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<UnitViewModel, UnitServer>
  createElement() {
    return _UnitViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is UnitViewModelProvider &&
        other.buildingId == buildingId &&
        other.unitId == unitId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, buildingId.hashCode);
    hash = _SystemHash.combine(hash, unitId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin UnitViewModelRef on AutoDisposeAsyncNotifierProviderRef<UnitServer> {
  /// The parameter `buildingId` of this provider.
  String get buildingId;

  /// The parameter `unitId` of this provider.
  String get unitId;
}

class _UnitViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<UnitViewModel, UnitServer>
    with UnitViewModelRef {
  _UnitViewModelProviderElement(super.provider);

  @override
  String get buildingId => (origin as UnitViewModelProvider).buildingId;
  @override
  String get unitId => (origin as UnitViewModelProvider).unitId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
