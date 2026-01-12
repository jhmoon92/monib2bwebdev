// lib/router.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/features/alert/presentation/alert_screen.dart';
import 'package:moni_pod_web/features/manage_building/presentation/manage_building_screen.dart';

import 'features/admin_member/presentation/admin_members_screen.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/presentation/signin_screen.dart';
import 'features/home/presentation/base_screen.dart';
// import 'features/home/presentation/dashboard_row_screen.dart';
import 'features/home/presentation/dashboard_screen.dart';
import 'features/manage_building/domain/unit_model.dart';
import 'features/manage_building/presentation/building_detail_screen.dart';
import 'features/manage_building/presentation/unit_detail_screen.dart';
import 'features/pod_assets/presentation/moni_pod_assets_screen.dart';

enum AppRoute { signIn, home, alerts, manageBuilding, buildingDetail, unitDetail, assets, members }

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.signIn:
        return "/signIn";
      case AppRoute.home:
        return "/home";
      case AppRoute.alerts:
        return '/alerts';
      case AppRoute.manageBuilding:
        return '/manageBuilding';
      case AppRoute.buildingDetail:
        return ':buildingId';
      case AppRoute.unitDetail:
        return 'unitDetail/:unitId';
      case AppRoute.assets:
        return '/assets';
      case AppRoute.members:
        return '/members';
    }
  }
}

// Building? findBuildingById(String id) {
//   try {
//     return buildings.firstWhere((b) => b.id == id);
//     // return buildings.firstWhere((b) => b.id == id);
//   } catch (e) {
//     return null;
//   }
// }
//
// Unit? findUnitById(String buildingId, String unitId) {
//   final building = findBuildingById(buildingId);
//   if (building == null) return null;
//   try {
//     return building.unitList.firstWhere((u) => u.id == unitId);
//     // return building.unitList.firstWhere((u) => u.id == unitId);
//   } catch (e) {
//     return null;
//   }
// }

final routerProvider = Provider<GoRouter>((ref) {
  // authController의 상태를 지켜봅니다.
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoute.signIn.path,

    // 상태가 변경될 때마다 리다이렉트 로직을 다시 실행하기 위해 설정
    // (AsyncNotifier를 사용할 경우 ref를 통해 상태 변화를 감지함)
    redirect: (context, state) {
      // 현재 로딩 중이거나 에러 상태라면 리다이렉트 하지 않음
      if (authState.isLoading || authState.hasError) return null;

      // 실제 데이터(토큰)가 있는지 확인
      final String? token = authState.value;
      final bool isLoggedIn = token != null && token.isNotEmpty;

      // 현재 위치 확인
      final bool isLoggingIn = state.matchedLocation == AppRoute.signIn.path;

      // 1. 로그인 안 됐는데 보호된 페이지에 접근하려 할 때 -> 로그인 페이지로
      if (!isLoggedIn) {
        return isLoggingIn ? null : AppRoute.signIn.path;
      }

      // 2. 로그인 됐는데 로그인 페이지에 있으려 할 때 -> 홈으로
      if (isLoggingIn) {
        return AppRoute.home.path;
      }

      // 3. 그 외에는 원래 가려던 곳으로
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) {
          final authState = ref.watch(authControllerProvider);
          if (authState.isLoading) return null; // 또는 스플래시 경로 반환
          final bool isLoggedIn = authState.value != null;
          return AppRoute.signIn.path;
        },
      ),
      GoRoute(
        path: AppRoute.signIn.path,
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) {
          return NoTransitionPage(key: state.pageKey, name: AppRoute.signIn.name, child: SignInScreen(apiBaseUrl: ''));
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BaseScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(key: state.pageKey, name: AppRoute.home.name, child: HomeScreen());
            },
          ),
          // GoRoute(
          //   path: AppRoute.alerts.path,
          //   name: AppRoute.alerts.name,
          //   pageBuilder: (context, state) {
          //     return NoTransitionPage(key: state.pageKey, name: AppRoute.alerts.name, child: AlertScreen());
          //   },
          // ),
          GoRoute(
            path: AppRoute.manageBuilding.path,
            name: AppRoute.manageBuilding.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(key: state.pageKey, name: AppRoute.manageBuilding.name, child: ManageBuildingScreen());
            },
            routes: [
              GoRoute(
                path: AppRoute.buildingDetail.path,
                name: AppRoute.buildingDetail.name,
                pageBuilder: (context, state) {
                  final buildingId = state.pathParameters['buildingId']!;
                  String buildingIdString = state.extra as String;
                  return NoTransitionPage(
                    key: state.pageKey,
                    name: AppRoute.buildingDetail.name,
                    child: BuildingDetailScreen(buildingId: buildingIdString),
                  );
                },
                routes: [
                  GoRoute(
                    path: AppRoute.unitDetail.path,
                    name: AppRoute.unitDetail.name,
                    pageBuilder: (context, state) {
                      final buildingId = state.pathParameters['buildingId']!;
                      final unitId = state.pathParameters['unitId']!;
                      Building building = state.extra as Building;
                      return NoTransitionPage(
                        key: state.pageKey,
                        name: AppRoute.unitDetail.name,
                        child: UnitDetailScreen(building: building, unitId: unitId), // Unit 객체 전달
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          // GoRoute(
          //   path: AppRoute.assets.path,
          //   name: AppRoute.assets.name,
          //   pageBuilder: (context, state) {
          //     return NoTransitionPage(key: state.pageKey, name: AppRoute.assets.name, child: MoniPodAssetsScreen());
          //   },
          // ),
          GoRoute(
            path: AppRoute.members.path,
            name: AppRoute.members.name,
            pageBuilder: (context, state) {
              return NoTransitionPage(key: state.pageKey, name: AppRoute.members.name, child: AdminMembersScreen());
            },
          ),
        ],
      ),
    ],
  );
});
