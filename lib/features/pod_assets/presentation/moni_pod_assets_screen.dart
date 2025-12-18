import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/features/home/presentation/base_screen.dart';
import 'package:data_table_2/data_table_2.dart';
import 'dart:html' if (dart.library.io) 'package:universal_html/html.dart' as html;

import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../../manage_building/domain/unit_model.dart';

class MoniPodAssetsScreen extends ConsumerStatefulWidget {
  const MoniPodAssetsScreen({super.key});

  @override
  ConsumerState<MoniPodAssetsScreen> createState() => _MoniPodAssetsScreenState();
}

class _MoniPodAssetsScreenState extends ConsumerState<MoniPodAssetsScreen> {
  TextEditingController controller = TextEditingController();
  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();
  DateTime _lastUpdatedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 12),
          Expanded(
            child: ScrollbarTheme(
              data: ScrollbarThemeData(thumbColor: WidgetStateProperty.all(commonGrey3), trackColor: WidgetStateProperty.all(commonGrey3)),
              child: Scrollbar(
                controller: verticalScrollController,
                interactive: true,
                thumbVisibility: true,
                thickness: 8.0,
                child: _buildDataTable(),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _handleRegisterDevice() {
    print('Register Device button pressed');
  }

  // 💡 3. Import CSV 기능 구현 (File Picker 사용)
  // void _handleImportCsv() async {
  //   // 웹 환경에서 File Picker 사용
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['csv'],
  //       allowMultiple: false,
  //     );
  //
  //     if (result != null && result.files.isNotEmpty) {
  //       final file = result.files.first;
  //       final bytes = file.bytes;
  //
  //       if (bytes != null) {
  //         // CSV 내용을 String으로 변환 (웹에서는 bytes로 접근)
  //         String csvContent = String.fromCharCodes(bytes);
  //
  //         // TODO: 실제로는 여기서 csvContent를 파싱하여 _assets 리스트를 업데이트해야 합니다.
  //         print('CSV File picked: ${file.name}');
  //         print('Content preview: ${csvContent.substring(0, csvContent.length > 200 ? 200 : csvContent.length)}');
  //
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${file.name}" 파일이 성공적으로 업로드되었으며, 데이터 파싱을 준비합니다.')));
  //         }
  //       }
  //     } else {
  //       // User canceled the picker
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 파일 선택이 취소되었습니다.')));
  //       }
  //     }
  //   } catch (e) {
  //     print('Error picking file: $e');
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('파일 선택 중 오류가 발생했습니다: $e')));
  //     }
  //   }
  // }

  // 💡 4. Export CSV 기능 구현 (dart:html 사용)
  void _handleExportCsv() {
    // 1. 헤더 정의 (표의 컬럼 순서와 일치시킴)
    final List<String> headers = [
      'SERIAL NUMBER',
      'BUILDING',
      'UNIT',
      'RESIDENT',
      'FIRMWARE',
      'STATUS',
      'INSTALLER',
      'REG.DATE'
    ];

    // 2. 데이터 행 생성 (표에 표시되는 데이터 로직과 동일하게 구성)
    final rows = allGlobalDevicesList.map((device) {
      final List<String> row = [
        device.serialNumber,
        device.buildingName,
        device.unitNumber,
        device.residentName,
        'v1.2.0', // 표에서 하드코딩된 펌웨어 버전 반영
        device.status == 'ONLINE' ? 'Online' : 'Offline',
        device.installer,
        DateFormat('yyyy.MM.dd. HH:mm').format(device.installationDate),
      ];

      // 데이터 내부에 쉼표(,)가 있을 경우 CSV 형식이 깨지므로 큰따옴표로 감싸줌
      return row.map((field) => '"${field.toString().replaceAll('"', '""')}"').join(',');
    }).toList();

    // 3. 전체 콘텐츠 병합 (엑셀 한글 깨짐 방지를 위해 \uFEFF 추가)
    final csvContent = '\uFEFF${headers.join(',')}\n${rows.join('\n')}';

    // 4. 다운로드 로직 (기존 코드 유지)
    if (kIsWeb) {
      try {
        final bytes = Uint8List.fromList(utf8.encode(csvContent)); // utf8 인코딩 사용
        final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
        final url = html.Url.createObjectUrlFromBlob(blob);

        final anchor = html.AnchorElement(href: url)
          ..setAttribute("download", "moni_pod_assets_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv")
          ..click();

        html.Url.revokeObjectUrl(url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 파일 다운로드를 시작합니다.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('다운로드 중 오류가 발생했습니다.')));
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('CSV 다운로드는 웹 환경에서만 지원됩니다.')));
      }
    }
  }
  // 💡 2. 상단 헤더 위젯 (반응형 구현은 기존 코드를 유지합니다.)
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 버튼이 검색창 아래로 내려갈 기준 너비 설정
          const double breakpoint = 800.0;
          final bool isNarrow = constraints.maxWidth < breakpoint;

          // 버튼 그룹 위젯
          final buttonGroup = Row(
            children: [
              InkWell(
                onTap: _handleExportCsv,
                child: Container(
                  width: 256,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/images/ic_24_download.svg'),
                      const SizedBox(width: 4),
                      Text('Export CSV', style: bodyTitle(commonWhite)),
                    ],
                  ),
                ),
              ),
            ],
          );

          // 검색 필드 위젯
          final searchField = Row(
            children: [
              isNarrow
                  ? Expanded(
                    // 화면이 넓을 때는 고정 너비, 좁을 때는 Expanded(남은 공간 모두 차지)
                    child: InputBox(
                      controller: controller,
                      placeHolder: "Search MAC, Building or Unit...",
                      maxLength: 50,
                      icon: Padding(padding: EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                      onSaved: (val) {},
                      textStyle: bodyCommon(commonBlack),
                      textType: 'normal',
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                  : SizedBox(
                    width: 380,
                    child: InputBox(
                      controller: controller,
                      placeHolder: "Search MAC, Building or Unit...",
                      maxLength: 50,
                      icon: Padding(padding: EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                      onSaved: (val) {},
                      textStyle: bodyCommon(commonBlack),
                      textType: 'normal',
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: 116,
                  decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: Text('Search', style: bodyTitle(commonWhite)),
                ),
              ),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              topTitle('Moni Pod List', 'Asset Management', _lastUpdatedTime, () {
                setState(() {
                  _lastUpdatedTime = DateTime.now();
                });
              }),
              if (!isNarrow) Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [searchField, const Spacer(), buttonGroup]),
              if (isNarrow)
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [searchField, const SizedBox(height: 16), buttonGroup]),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDataTable() {
    const double minTableWidth = 1600.0;

    return Container(
      decoration: BoxDecoration(
        color: commonWhite, // 전체 배경 흰색
        borderRadius: BorderRadius.circular(8), // 테두리 Radius 8
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8), // 내부 내용이 테두리를 넘지 않게 자름
        child: DataTable2(
          scrollController: verticalScrollController,
          horizontalScrollController: horizontalScrollController,
          fixedTopRows: 1,
          minWidth: minTableWidth,
          headingRowColor: WidgetStateProperty.all<Color>(commonWhite),
          border: TableBorder(
            horizontalInside: BorderSide(color: commonGrey2, width: 1.0),
            bottom: BorderSide(color: commonGrey5, width: 1.0),
          ),
          columnSpacing: 30, // 열 간격 조정
          horizontalMargin: 0,
          headingRowHeight: 48,
          dataRowHeight: 56, // 행 높이 조정
          columns: [
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 24), child: Text('SERIAL NUMBER', style: bodyTitle(commonBlack))),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('BUILDING', style: bodyTitle(commonBlack))),
              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('UNIT', style: bodyTitle(commonBlack))),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('RESIDENT', style: bodyTitle(commonBlack))),
              size: ColumnSize.L,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('FIRMWARE', style: bodyTitle(commonBlack))),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('STATUS', style: bodyTitle(commonBlack))),
              size: ColumnSize.S,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('INSTALLER', style: bodyTitle(commonBlack))),

              size: ColumnSize.M,
            ),
            DataColumn2(
              label: Padding(padding: EdgeInsets.only(left: 16), child: Text('REG.DATE', style: bodyTitle(commonBlack))),
              size: ColumnSize.L,
            ),
          ],
          rows:
              allGlobalDevicesList
                  .map(
                    (device) => DataRow(
                      cells: [
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 24),
                            child: Text(device.serialNumber, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(device.buildingName, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(device.unitNumber, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/images/ic_24_person.svg',
                                  colorFilter: ColorFilter.mode(commonBlack, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    device.residentName,
                                    style: bodyCommon(commonBlack),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text('v1.2.0', style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Container(
                              height: 24,
                              width: 78,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: device.status == 'ONLINE' ? successGreenBg1 : commonGrey2,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 6,
                                    width: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: device.status == 'ONLINE' ? successGreen : commonGrey6,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    device.status == 'ONLINE' ? 'Online' : 'Offline',
                                    style: captionPoint(device.status == 'ONLINE' ? successGreen : commonGrey6),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(device.installer, style: bodyCommon(commonBlack), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                        DataCell(
                          Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Text(
                              DateFormat('yyyy.MM.dd. HH:mm').format(device.installationDate),
                              style: bodyCommon(commonGrey6),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}
