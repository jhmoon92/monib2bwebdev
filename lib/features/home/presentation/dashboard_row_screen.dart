// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:moni_pod_web/features/manage_building/domain/unit_model.dart';
//
// import '../../../common_widgets/status_chip.dart';
// import '../../../config/style.dart';
// import 'base_screen.dart';
// import 'home_detail_dialog.dart' hide StatusChip;
// import 'map_screen.dart';
// // SVG 파일을 사용하고 있다면 아래 임포트가 필요합니다.
// // import 'package:flutter_svg/svg.dart';
//
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   List<Unit> criticalUnits = [];
//   List<Unit> warningUnits = [];
//   DateTime _lastUpdatedTime = DateTime.now();
//
//   // 레이아웃 변경 임계점 (필요에 따라 값 변경 가능)
//   static const double _kBreakpoint = 1000.0;
//   // 스택 레이아웃일 때 지도의 고정 높이
//   static const double _kMapFixedHeight = 500.0;
//
//   @override
//   void initState() {
//     // allUnits는 unit_model.dart에 정의되어 있다고 가정
//     criticalUnits = allUnits.where((unit) => unit.status == 'critical').toList();
//     warningUnits = allUnits.where((unit) => unit.status == 'warning').toList();
//     super.initState();
//   }
//
//   // =========================================================================
//   // Status 섹션 (Critical/Warning 카드)
//   // =========================================================================
//   Widget _buildStatusSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         InkWell(
//           onTap: () {
//             showCriticalUnitsDialog(context, true);
//           },
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: commonWhite,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   StatusChip(status: 'critical'),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Text(criticalUnits.length.toString(), style: headLineLarge(commonBlack)),
//                       const SizedBox(width: 8),
//                       Padding(padding: const EdgeInsets.only(top: 12), child: Text('Units', style: bodyTitle(commonGrey5))),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text('Require immediate attention', style: bodyCommon(commonGrey7)),
//                   const SizedBox(height: 16),
//                   Text('Critical Alert: No movement for over 24 hours.', style: bodyTitle(Colors.red)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(height: 24),
//         InkWell(
//           onTap: () {
//             showCriticalUnitsDialog(context, false);
//           },
//           child: Container(
//             width: double.infinity,
//             decoration: BoxDecoration(
//               color: commonWhite,
//               borderRadius: BorderRadius.circular(8),
//               boxShadow: [
//                 BoxShadow(color: commonBlack.withOpacity(0.25), offset: const Offset(0, 4), blurRadius: 4, spreadRadius: 0),
//               ],
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   StatusChip(status: 'warning'),
//                   const SizedBox(height: 16),
//                   Row(
//                     children: [
//                       Text(warningUnits.length.toString(), style: headLineLarge(commonBlack)),
//                       const SizedBox(width: 8),
//                       Padding(padding: const EdgeInsets.only(top: 12), child: Text('Units', style: bodyTitle(commonGrey5))),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text('Monitor for potential issues', style: bodyCommon(commonGrey7)),
//                   const SizedBox(height: 16),
//                   Text('Warning Alert: No movement between 8 and 24 hours.', style: bodyTitle(themeYellow)),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildMapSection({required bool isStacked}) {
//     final Widget mapContent = Container(
//       height: isStacked ? _kMapFixedHeight : null,
//       width: double.infinity,
//       alignment: Alignment.center,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         border: isStacked ? Border.all(color: commonGrey2, width: 1) : null,
//       ),
//       child: ClipRRect(borderRadius: BorderRadius.circular(8), child: const GoogleMapSearchScreen()),
//     );
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Global Activity Map', style: titleMedium(commonBlack)),
//         const SizedBox(height: 16),
//         isStacked ? mapContent : Expanded(child: mapContent),
//         const SizedBox(height: 56),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         topTitle('DashBoard', 'Real-time system overview', DateTime.now(), () {
//           setState(() {
//             _lastUpdatedTime = DateTime.now();
//           });
//         }),
//         const SizedBox(height: 16),
//         Expanded(
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               final double screenWidth = constraints.maxWidth;
//               final bool isStacked = screenWidth < _kBreakpoint;
//
//               final Widget statusSection = _buildStatusSection();
//               final Widget mapSection = _buildMapSection(isStacked: isStacked);
//
//               if (!isStacked) {
//                 // Wide screen: Row layout
//                 return Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(child: statusSection),
//                     const SizedBox(width: 32),
//                     Expanded(child: mapSection),
//                   ],
//                 );
//               } else {
//                 return SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       statusSection, // Status 섹션
//                       const SizedBox(height: 32),
//                       mapSection,
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }