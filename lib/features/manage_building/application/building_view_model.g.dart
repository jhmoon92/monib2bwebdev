// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$buildingViewModelHash() => r'0aaca7bbf86d2a3a02df089a76f37ec2aed53411';

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

abstract class _$BuildingViewModel
    extends BuildlessAutoDisposeAsyncNotifier<Building> {
  late final String buildingId;

  FutureOr<Building> build(String buildingId);
}

/// See also [BuildingViewModel].
@ProviderFor(BuildingViewModel)
const buildingViewModelProvider = BuildingViewModelFamily();

/// See also [BuildingViewModel].
class BuildingViewModelFamily extends Family<AsyncValue<Building>> {
  /// See also [BuildingViewModel].
  const BuildingViewModelFamily();

  /// See also [BuildingViewModel].
  BuildingViewModelProvider call(String buildingId) {
    return BuildingViewModelProvider(buildingId);
  }

  @override
  BuildingViewModelProvider getProviderOverride(
    covariant BuildingViewModelProvider provider,
  ) {
    return call(provider.buildingId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'buildingViewModelProvider';
}

/// See also [BuildingViewModel].
class BuildingViewModelProvider
    extends AutoDisposeAsyncNotifierProviderImpl<BuildingViewModel, Building> {
  /// See also [BuildingViewModel].
  BuildingViewModelProvider(String buildingId)
    : this._internal(
        () => BuildingViewModel()..buildingId = buildingId,
        from: buildingViewModelProvider,
        name: r'buildingViewModelProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$buildingViewModelHash,
        dependencies: BuildingViewModelFamily._dependencies,
        allTransitiveDependencies:
            BuildingViewModelFamily._allTransitiveDependencies,
        buildingId: buildingId,
      );

  BuildingViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.buildingId,
  }) : super.internal();

  final String buildingId;

  @override
  FutureOr<Building> runNotifierBuild(covariant BuildingViewModel notifier) {
    return notifier.build(buildingId);
  }

  @override
  Override overrideWith(BuildingViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: BuildingViewModelProvider._internal(
        () => create()..buildingId = buildingId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        buildingId: buildingId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<BuildingViewModel, Building>
  createElement() {
    return _BuildingViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BuildingViewModelProvider && other.buildingId == buildingId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, buildingId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BuildingViewModelRef on AutoDisposeAsyncNotifierProviderRef<Building> {
  /// The parameter `buildingId` of this provider.
  String get buildingId;
}

class _BuildingViewModelProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<BuildingViewModel, Building>
    with BuildingViewModelRef {
  _BuildingViewModelProviderElement(super.provider);

  @override
  String get buildingId => (origin as BuildingViewModelProvider).buildingId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
