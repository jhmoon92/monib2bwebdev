import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:moni_pod_web/common/provider/sensing/building_resp.dart';
import 'package:moni_pod_web/common_widgets/async_value_widget.dart';
import 'package:moni_pod_web/common_widgets/button.dart';
import 'package:moni_pod_web/features/admin_member/application/member_view_model.dart';
import 'package:moni_pod_web/features/manage_building/application/buildings_view_model.dart';
import 'package:moni_pod_web/features/manage_building/domain/unit_model.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../../admin_member/domain/member_model.dart';
import '../../admin_member/presentation/admin_members_screen.dart';
import '../../home/presentation/map_screen.dart';
import 'dart:js_util' as js_util;
import 'dart:js' as js;

const String googleApiKey = 'AIzaSyBUc2bj_VUyH-kmgsFJxDgT4OXBUQBp2O0';

class Manager {
  final String name;
  final String id;
  final bool isMaster;

  Manager({required this.name, required this.id, this.isMaster = false});
}

void showAddBuildingDialog(BuildContext context) {
  showCustomDialog(context: context, title: 'Add Building', content: const SizedBox(width: 680, height: 700, child: AddBuildingDialog()));

  // showCustomDialog(context: context, title: 'Add Building', content: AddBuildingDialog());
}

class AddBuildingDialog extends ConsumerStatefulWidget {
  const AddBuildingDialog({super.key});
  @override
  ConsumerState<AddBuildingDialog> createState() => _AddBuildingDialogState();
}

class _AddBuildingDialogState extends ConsumerState<AddBuildingDialog> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _startFloorController = TextEditingController();
  final TextEditingController _endFloorController = TextEditingController();
  final TextEditingController _unitsPerFloorController = TextEditingController();
  final TextEditingController _customUnitController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _previewScrollController = ScrollController();
  Timer? _debounce;
  double _progressbarValue1 = 0;
  bool isStep1 = true;
  late TabController _tabController;
  late Animation<double> _animation1;
  late AnimationController _controller1;
  double latitude = 0.0;
  double longitude = 0.0;
  List<ManagerServer> managerList = [];
  List<UnitServer> unitList = [];

  List<String> _unitSet = [];

  // final List<Manager> _managers = [
  //   Manager(name: 'Yamada Taro (Master)', id: 'taro_admin', isMaster: true),
  //   Manager(name: 'Tanaka Kenji', id: 'tanaka_k'),
  //   Manager(name: 'Sato Haruka', id: 'sato_h'),
  //   Manager(name: 'Suzuki Ryota', id: 'suzuki_r'),
  //   Manager(name: 'Takahashi Aoi', id: 'takahashi_a'),
  //   Manager(name: 'Watanabe Yui', id: 'watanabe_y'),
  // ];

  Map<String, bool> _selectedManagers = {};

  // 선택된 이미지 파일 이름
  String? _imageFileName;
  // 2. 이미지 미리보기를 위한 바이트 데이터 저장
  Uint8List? _imageFileBytes;

  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  final TextEditingController _controller = TextEditingController();
  OverlayEntry? _overlayEntry;
  List<Map<String, dynamic>> _predictions = [];

  @override
  void initState() {
    super.initState();
    _generateUnits();

    _tabController = TabController(length: 2, vsync: this, animationDuration: const Duration(milliseconds: 500));
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(seconds: 1),
    );
    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.easeIn);
    _animation1.addListener(() {
      if (mounted)
        setState(() {
          _progressbarValue1 = _animation1.value;
        });
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 150), () {
          if (!_focusNode.hasFocus) {
            _hideOverlay();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _addressController.dispose();
    _debounce?.cancel();
    _controller1.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _startFloorController.dispose();
    _endFloorController.dispose();
    _unitsPerFloorController.dispose();
    _customUnitController.dispose();
    super.dispose();
  }

  Future<void> _waitGoogleMapsReady({Duration timeout = const Duration(seconds: 10)}) async {
    final start = DateTime.now();
    while (true) {
      final readyFlag = js.context['__gmapsReady'] == true;
      final hasGoogle = js_util.hasProperty(js.context, 'google');
      if (readyFlag && hasGoogle) return;

      if (DateTime.now().difference(start) > timeout) {
        throw StateError('Google Maps JS SDK not ready. (script load 실패/키/리퍼러/API/Billing 확인)');
      }
      await Future<void>.delayed(const Duration(milliseconds: 80));
    }
  }

  void _getAutocomplete(String input) async {
    if (input.isEmpty) {
      _hideOverlay();
      setState(() => _predictions = []);
      return;
    }

    js.context.callMethod('getGooglePredictions', [
      input,
      js.allowInterop((predictions) {
        setState(() {
          // [수정] JsArray를 Dart List로 변환

          final List<dynamic> decoded = jsonDecode(predictions);
          _predictions = decoded.cast<Map<String, dynamic>>();

          // _predictions = List<dynamic>.from(predictions);

          if (_predictions.isNotEmpty) {
            _showOverlay();
          } else {
            _hideOverlay();
          }
        });
      }),
    ]);
  }

  void _showOverlay() {
    _hideOverlay(); // 기존 오버레이 제거
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  // 2. 이미지 파일 선택 및 미리보기 구현 (웹 전용)
  void _pickImage() {
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*'; // 이미지 파일만 선택하도록 설정
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      if (files!.isNotEmpty) {
        final file = files[0];

        // 파일을 읽어서 바이트 데이터로 변환 (미리보기를 위함)
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) {
          if (reader.result != null) {
            setState(() {
              _imageFileName = file.name;
              _imageFileBytes = reader.result as Uint8List;
            });
          }
        });
      }
    });
  }

  // 건물 추가 버튼 클릭
  void _handleAddBuilding() {
    // if (_formKey.currentState!.validate()) {
    //   // 폼 데이터 수집
    //   final data = {
    //     'name': _buildingNameController.text,
    //     'address': _addressController.text,
    //     // 실제로는 _imageFileBytes를 서버로 업로드하는 로직 필요
    //     'imageFileName': _imageFileName,
    //     'managers': _selectedManagers.entries.where((e) => e.value).map((e) => e.key).toList(),
    //   };
    //
    //   // [NOTE] 실제로는 여기서 데이터를 백엔드로 전송하는 로직 구현
    //   print('건물 추가 데이터: $data');
    //
    //   // 다이얼로그 닫기
    //   Navigator.of(context).pop();
    // }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(memberViewModelProvider, (previous, next) {
      next.whenData((data) {
        final list = data as List<Member>;

        list.sort((a, b) {
          int getPriority(int authority) {
            switch (authority) {
              case 1: return 1;
              case 20: return 2;
              case 50: return 3;
              default: return 4; // etc
            }
          }

          return getPriority(a.authority).compareTo(getPriority(b.authority));
        });

        if (list.isNotEmpty && _selectedManagers.isEmpty) {
          // 아직 초기화되지 않은 경우만 실행
          setState(() {
            managerList.clear();
            for (var member in list) {
              bool isMaster = (member.authority == 1);
              _selectedManagers[member.id.toString()] = isMaster;
              if (isMaster) {
                managerList.add(ManagerServer(id: member.id, name: member.name, phoneNumber: member.phoneNumber, email: member.email));
              }
            }
          });
        }
      });
    });

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            stepper(context),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우 패딩만 유지
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Tab(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),
                            Text('Basic Info', style: bodyCommon(commonGrey5)),
                            const SizedBox(height: 24),
                            _buildImageUploader(),
                            const SizedBox(height: 28),
                            _buildAddressInput(),
                            const SizedBox(height: 28),
                            _buildRegion(),
                            const SizedBox(height: 28),
                            inputText(
                              'Building Name',
                              'e.g.Sunrise Senior Care',
                              _buildingNameController,
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: SvgPicture.asset(
                                  'assets/images/ic_24_office.svg',
                                  width: 16,
                                  fit: BoxFit.fitWidth,
                                  colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                                ),
                              ),
                              isRequired: true,
                            ),
                            const SizedBox(height: 28),
                            SizedBox(height: 160, child: _buildAssignedManagers()),
                          ],
                        ),
                      ),
                    ),
                    // Tab 2 Content
                    Tab(child: step2Screen()),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isStep1
                      ? Container()
                      : InkWell(
                        onTap: () {
                          Future.delayed(const Duration(milliseconds: 10), () {
                            if (mounted) {
                              setState(() {
                                FocusScope.of(context).unfocus();
                                _controller1.reverse();
                                _tabController.animateTo(0);
                                isStep1 = true;
                              });
                            }
                          });
                        },
                        child: Container(
                          width: 256,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: commonWhite,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: commonGrey2, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/ic_24_previous.svg',
                                colorFilter: const ColorFilter.mode(commonBlack, BlendMode.srcIn),
                              ),
                              const SizedBox(width: 4),
                              Text('Back', style: bodyTitle(commonBlack)),
                            ],
                          ),
                        ),
                      ),

                  Expanded(child: SizedBox()),
                  isStep1
                      ? InkWell(
                        onTap: () {
                          if (_addressController.text.isNotEmpty && _buildingNameController.text.isNotEmpty) {
                            _controller1.forward();
                            _tabController.animateTo(1);
                            if (mounted) {
                              setState(() {
                                isStep1 = false;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 256,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                _addressController.text.isNotEmpty && _buildingNameController.text.isNotEmpty ? themeYellow : commonGrey5,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: bodyTitle(
                                  _addressController.text.isNotEmpty && _buildingNameController.text.isNotEmpty ? commonWhite : commonGrey6,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_right_alt,
                                size: 24,
                                color:
                                    _addressController.text.isNotEmpty && _buildingNameController.text.isNotEmpty
                                        ? commonWhite
                                        : commonGrey6,
                              ),
                            ],
                          ),
                        ),
                      )
                      : InkWell(
                        onTap: () async {
                          unitList =
                              _unitSet.map((unitName) {
                                return UnitServer(name: unitName);
                              }).toList();

                          BuildingServer building = BuildingServer(
                            id: "",
                            name: _buildingNameController.text,
                            image: '',
                            region: _regionController.text,
                            address: _addressController.text,
                            latitude: latitude,
                            longitude: longitude,
                            managers: managerList,
                            units: unitList,
                          );
                          await ref.read(buildingsViewModelProvider.notifier).addBuilding(building);
                          context.pop();
                          await ref.read(buildingsViewModelProvider.notifier).fetchData();
                        },
                        child: Container(
                          width: 256,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                          child: Text('Add Building', style: bodyTitle(commonWhite)),
                        ),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget stepper(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Column(children: [Container(height: 8, decoration: BoxDecoration(color: themeYellow))])),
        Expanded(
          child: Column(
            children: [LinearProgressIndicator(minHeight: 8, backgroundColor: commonGrey2, color: themeYellow, value: _progressbarValue1)],
          ),
        ),
      ],
    );
  }

  Widget _buildAddressInput() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 24,
          child: RichText(
            text: TextSpan(
              text: 'Address Search',
              style: titleCommon(commonBlack),
              children: [TextSpan(text: ' *', style: titleCommon(Colors.red))],
            ),
          ),
        ),
        Expanded(
          flex: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompositedTransformTarget(
                link: _layerLink,
                child: InputBox(
                  controller: _addressController,
                  focus: _focusNode,
                  label: 'Type to search (e.g. Seoul)...',
                  maxLength: 32,
                  isErrorText: true,
                  icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
                  onSaved: (val) {},
                  textStyle: bodyCommon(commonBlack),
                  textType: 'normal',
                  validator: (value) => value == null || value.isEmpty ? 'Please Enter Address' : null,
                  onChanged: (value) {
                    // Debounce: 입력이 멈추고 0.3초 뒤에 검색 실행 (API 비용 절감)
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(Duration(milliseconds: 300), () {
                      _getAutocomplete(value);
                    });
                  },
                ),

                // TextField(
                //   controller: _controller,
                //   focusNode: _focusNode,
                //   decoration: InputDecoration(border: OutlineInputBorder(), hintText: "주소를 입력하세요"),
                //   onChanged: (value) async {
                //     // 여기서 API 호출 및 결과 업데이트
                //     // 예시: predictions = await service.searchAddress(value);
                //     // 데이터가 오면 _hideOverlay() 후 _showOverlay() 호출
                //   },
                // ),
              ),
              //   InputBox(
              //     controller: _addressController,
              //     label: 'Type to search (e.g. Seoul)...',
              //     maxLength: 32,
              //     isErrorText: true,
              //     icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
              //     onSaved: (val) {},
              //     textStyle: bodyCommon(commonBlack),
              //     textType: 'normal',
              //     validator: (value) => value == null || value.isEmpty ? 'Please Enter Address' : null,
              //     onChanged: _onAddressSearch,
              //   ),
              //   // 검색 결과 목록
              //   if (_addressSuggestions.isNotEmpty)
              //     Container(
              //       decoration: BoxDecoration(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(8),
              //         boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 4)],
              //       ),
              //       margin: const EdgeInsets.only(top: 8),
              //       child: ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: _addressSuggestions.length,
              //         itemBuilder: (context, index) {
              //           final suggestion = _addressSuggestions[index];
              //           return ListTile(
              //             // 2. 검색 제안 텍스트 색상 검은색으로 변경
              //             title: Text(suggestion, style: bodyCommon(commonBlack)),
              //             leading: const Icon(Icons.location_on, size: 20, color: themeYellow),
              //             onTap: () => _selectAddress(suggestion),
              //           );
              //         },
              //       ),
              //     ),
            ],
          ),
        ),
      ],
    );
  }

  // 오버레이 생성 함수
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder:
          (context) => Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              targetAnchor: Alignment.bottomLeft,
              followerAnchor: Alignment.topLeft,
              offset: const Offset(0, 5),
              child: MouseRegion(
                // 웹에서 커서 모양 변경을 위해 추가
                cursor: SystemMouseCursors.click,
                child: Material(
                  // 🚨 필수: 클릭 이벤트 전달을 위해 필요
                  elevation: 8,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: _predictions.length,
                      itemBuilder: (context, index) {
                        // 여기서 item을 명확히 정의
                        final item = _predictions[index];
                        // JS 객체라면 js_util로, Map이라면 아래처럼 접근
                        final String description = item['description'] ?? "";

                        return ListTile(
                          leading: const Icon(Icons.location_on, color: themeYellow),
                          title: Text(description, style: bodyCommon(commonBlack)),
                          onTap: () {
                            // 1. placeId가 제대로 있는지 먼저 확인
                            final String placeId = item['place_id'] ?? "";
                            if (placeId == "") {
                              debugPrint("에러: Place ID가 없습니다.");
                              return;
                            }

                            debugPrint("선택된 Place ID: $placeId");

                            js.context.callMethod('getPlaceDetails', [
                              placeId,
                              js.allowInterop((dynamic jsonResponse) {
                                // String 대신 dynamic 사용
                                if (jsonResponse != null && jsonResponse is String) {
                                  try {
                                    // 문자열로 들어온 데이터를 Dart Map으로 변환
                                    final Map<String, dynamic> result = jsonDecode(jsonResponse);

                                    setState(() {
                                      _addressController.text = result['address'] ?? "";
                                      _regionController.text = result['region'] ?? "";
                                      latitude = result['latitude'] ?? 0.0;
                                      longitude = result['longitude'] ?? 0.0;
                                    });
                                  } catch (e) {
                                    debugPrint("JSON 파싱 에러: $e");
                                  }
                                } else {
                                  debugPrint("응답이 문자열이 아니거나 비어있음: $jsonResponse");
                                }
                                _hideOverlay();
                              }),
                            ]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildRegion() {
    return Row(
      children: [
        Expanded(
          flex: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Region', style: titleCommon(commonBlack)), Text('(Auto-Filled)', style: bodyCommon(commonGrey5))],
          ),
        ),
        Expanded(
          flex: 44,
          child: Stack(
            children: [
              InputBox(
                controller: _regionController,
                label: 'Select address first',
                maxLength: 32,
                isErrorText: true,
                onSaved: (val) {},
                textStyle: bodyCommon(commonBlack),
                textType: 'normal',
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    'assets/images/ic_24_location.svg',
                    width: 16,
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Address' : null,
              ),
              Container(
                width: double.infinity,
                height: 42,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: commonGrey2.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 24, child: Text('Building Image', style: titleCommon(commonBlack))),
        Expanded(
          flex: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  // BorderStyle.dashed를 BorderStyle.none으로 변경
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.none),
                ),
                child: InkWell(
                  onTap: _pickImage, // PC 파일 탐색기 열기
                  borderRadius: BorderRadius.circular(8),
                  child: Center(
                    // 2. 이미지 미리보기 로직
                    child:
                        _imageFileBytes != null
                            ? Stack(
                              fit: StackFit.expand,
                              children: [
                                // 미리보기 이미지
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(_imageFileBytes!, fit: BoxFit.cover, alignment: Alignment.center),
                                ),
                                // 파일 이름 오버레이
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _imageFileName!,
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // 아이콘 오버레이 (선택됨 표시)
                                Positioned(top: 8, right: 8, child: Icon(Icons.check_circle, size: 24, color: themeYellow)),
                              ],
                            )
                            // 파일이 선택되지 않은 경우
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/images/ic_24_upload.svg"),
                                const SizedBox(height: 12),
                                Text('Select an image file or drag and drop it.', style: bodyCommon(commonGrey6)),
                              ],
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 5. Assigned Managers 위젯
  Widget _buildAssignedManagers() {
    List<Member> memberList = [];

    return AsyncProviderWidget(
      provider: memberViewModelProvider,
      onTry: () async {
        ref.read(memberViewModelProvider.notifier).fetchData();
      },
      data: (data) {
        memberList = data as List<Member>;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 24, child: Text('Assigned Managers', style: titleCommon(commonBlack))),
            Expanded(
              flex: 44,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 160.0),
                    child: Container(
                      decoration: BoxDecoration(border: Border.all(color: commonGrey2, width: 1), borderRadius: BorderRadius.circular(8)),
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thumbColor: WidgetStateProperty.all(commonGrey3),
                          trackColor: WidgetStateProperty.all(Colors.grey.shade300),
                        ),
                        child: Scrollbar(
                          controller: _scrollController,
                          interactive: true,
                          thumbVisibility: true,
                          thickness: 8.0,
                          child: ListView.builder(
                            clipBehavior: Clip.antiAlias,
                            padding: EdgeInsets.zero,
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: memberList.length,
                            itemBuilder: (context, index) {
                              final manager = memberList[index];
                              final isChecked = _selectedManagers[manager.id.toString()] ?? false;
                              final isDisabled = (manager.authority == 1); // Master Admin은 선택 해제 불가
                              return Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: isDisabled ? commonGrey2 : Colors.white,
                                  // 하단 경계선이 필요하다면 추가 (선택사항)
                                  border: Border(bottom: BorderSide(color: commonGrey1, width: 0.5)),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    checkboxTheme: CheckboxThemeData(
                                      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
                                        // 비활성화(disabled) 상태일 때 원하는 진한 회색을 반환
                                        if (states.contains(WidgetState.disabled)) {
                                          return commonGrey5; // ✅ 여기서 회색의 농도를 조절하세요 (예: commonGrey6)
                                        }
                                        return null; // 그 외 상태는 기본 테마(activeColor 등)를 따름
                                      }),
                                    ),
                                  ),
                                  child: CheckboxListTile(
                                    title: Text(manager.name, style: bodyCommon(isDisabled ? commonGrey5 : commonBlack)),
                                    value: isDisabled ? true : isChecked, // 비활성화 항목은 체크 고정
                                    onChanged:
                                        isDisabled
                                            ? null
                                            : (bool? newValue) {
                                              setState(() {
                                                if (newValue ?? false) {
                                                  managerList.add(
                                                    ManagerServer(
                                                      id: manager.id,
                                                      name: manager.name,
                                                      email: manager.email,
                                                      phoneNumber: manager.phoneNumber,
                                                    ),
                                                  );
                                                } else {
                                                  managerList.removeWhere((item) => item.id == index);
                                                }
                                                _selectedManagers[manager.id.toString()] = newValue ?? false;
                                              });
                                            },
                                    visualDensity: const VisualDensity(horizontal: 0, vertical: -4), // ✅ 수직 밀도를 최소로 줄임
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // ✅ 세로 패딩 제거
                                    controlAffinity: ListTileControlAffinity.leading,
                                    checkColor: Colors.white,
                                    activeColor: themeYellow,
                                    // tileColor: isDisabled ? commonGrey2 : Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget inputText(String title, String hint, TextEditingController controller, Widget icon, {bool isRequired = false}) {
    return Row(
      children: [
        Expanded(
          flex: 24,
          child: RichText(
            text: TextSpan(
              text: title,
              style: titleCommon(commonBlack),
              children: [if (isRequired) TextSpan(text: ' *', style: titleCommon(Colors.red))],
            ),
          ),
        ),
        Expanded(
          flex: 44,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              InputBox(
                controller: controller,
                label: hint,
                maxLength: 32,
                isErrorText: true,
                icon: icon,
                onSaved: (val) {},
                textStyle: bodyCommon(commonBlack),
                textType: 'normal',
                validator: (value) {
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _generateUnits() {
    final int? startFloor = int.tryParse(_startFloorController.text);
    final int? endFloor = int.tryParse(_endFloorController.text);
    final int? unitsPerFloor = int.tryParse(_unitsPerFloorController.text);

    if (startFloor == null || endFloor == null || unitsPerFloor == null || unitsPerFloor <= 0) {
      return;
    }

    final Set<int> generatedUnits = {};
    int currentFloor;

    if (startFloor <= endFloor) {
      for (currentFloor = startFloor; currentFloor <= endFloor; currentFloor++) {
        for (int unit = 1; unit <= unitsPerFloor; unit++) {
          int unitNumber = currentFloor * 100 + unit;
          generatedUnits.add(unitNumber);
        }
      }
    } else {
      for (currentFloor = startFloor; currentFloor >= endFloor; currentFloor--) {
        for (int unit = 1; unit <= unitsPerFloor; unit++) {
          int unitNumber = currentFloor * 100 + unit;
          generatedUnits.add(unitNumber);
        }
      }
    }

    List<int> sortedIntUnits = generatedUnits.toList();
    sortedIntUnits.sort((a, b) => b.compareTo(a));
    List<String> finalDisplayUnits = sortedIntUnits.map((unit) => unit.toString()).toList();
    setState(() {
      _unitSet = finalDisplayUnits;
    });
  }

  void _deleteUnit(String unitNumber) {
    if (!unitNumber.contains('유효한')) {
      setState(() {
        _unitSet.remove(unitNumber);
      });
    }
  }

  void _addCustomUnit() {
    final String customUnit = _customUnitController.text.trim();
    if (customUnit.isEmpty) return;

    // 유효성 검사: 숫자만, 중복 X
    if (!RegExp(r'^\d+$').hasMatch(customUnit)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('유닛 번호는 숫자만 입력 가능합니다.')));
      return;
    }

    if (_unitSet.contains(customUnit)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('이미 목록에 존재하는 유닛 번호입니다.')));
      return;
    }

    setState(() {
      _unitSet.add(customUnit);
      _customUnitController.clear();
    });
  }

  // 7. 텍스트 필드 템플릿
  Widget _buildTextField({required String label, required TextEditingController controller}) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: titleCommon(commonBlack)),
          const SizedBox(height: 4),
          InputBox(
            controller: controller,
            label:
                label == 'Start Floor'
                    ? '1'
                    : label == 'End Floor'
                    ? '12'
                    : '4',
            maxLength: 4,
            isErrorText: true,
            onSaved: (val) {},
            textStyle: bodyCommon(commonBlack),
            textType: 'number',
            validator: (value) {
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget step2Screen() {
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text('Unit Generator', style: bodyCommon(commonGrey5)),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 24, child: Text('Configuration', style: titleCommon(commonBlack))),
              Expanded(
                flex: 44,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildTextField(label: 'Start Floor', controller: _startFloorController),
                        const SizedBox(width: 16),
                        _buildTextField(label: 'End Floor', controller: _endFloorController),
                        const SizedBox(width: 16),
                        _buildTextField(label: 'Units per Floor', controller: _unitsPerFloorController),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: _generateUnits,
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                                _startFloorController.text.isNotEmpty &&
                                        _endFloorController.text.isNotEmpty &&
                                        _unitsPerFloorController.text.isNotEmpty
                                    ? themeYellow
                                    : commonGrey3,
                          ),
                          child: Text('Generate Preview', style: bodyTitle(commonWhite)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 24, child: Text('Preview (${_unitSet.length})', style: titleCommon(commonBlack))),
              Expanded(
                flex: 44,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 360,
                      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 4),
                      decoration: BoxDecoration(color: commonGrey1, borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: InputBox(
                                  controller: _customUnitController,
                                  label: 'Add Custom...',
                                  maxLength: 4,
                                  isErrorText: true,
                                  onSaved: (val) {},
                                  textStyle: bodyCommon(commonBlack),
                                  textType: 'number',
                                  validator: (value) {
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: _addCustomUnit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: themeYellow,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                  child: const Icon(Icons.add, size: 24, color: commonWhite),
                                ),
                              ),
                              const SizedBox(width: 16),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child:
                                _unitSet.isNotEmpty
                                    ? ScrollbarTheme(
                                      data: ScrollbarThemeData(
                                        thumbColor: WidgetStateProperty.all(commonGrey4),
                                        trackColor: WidgetStateProperty.all(commonGrey2),
                                      ),
                                      child: Scrollbar(
                                        controller: _previewScrollController,
                                        interactive: true,
                                        thumbVisibility: true,
                                        thickness: 8.0,
                                        child: SingleChildScrollView(
                                          controller: _previewScrollController,
                                          child: Wrap(
                                            spacing: 8.0,
                                            runSpacing: 8.0,
                                            children:
                                                _unitSet.map((unit) {
                                                  if (unit.contains('유효한')) {
                                                    return Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                                                      child: Text(unit, style: TextStyle(color: commonBlack)),
                                                    );
                                                  }
                                                  return _UnitChip(unitNumber: unit, onDelete: _deleteUnit);
                                                }).toList(),
                                          ),
                                        ),
                                      ),
                                    )
                                    : Center(child: Text('No units generated yet.', style: bodyCommon(commonGrey5))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UnitChip extends StatefulWidget {
  final String unitNumber;
  final ValueChanged<String> onDelete;

  const _UnitChip({required this.unitNumber, required this.onDelete});

  @override
  State<_UnitChip> createState() => _UnitChipState();
}

class _UnitChipState extends State<_UnitChip> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // 예: 2px씩 확장
            decoration: BoxDecoration(
              color: Colors.transparent, // 배경색 지정 (원하는 색상으로 변경)
            ),
            child: Text(widget.unitNumber, style: bodyTitle(Colors.transparent)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: cautionYellowBg1,
              border: Border.all(color: themeYellow),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(widget.unitNumber, style: bodyTitle(commonBlack)),
          ),

          // 2. 🚨 호버 시 나타나는 삭제 버튼 ('X' 아이콘)
          if (_isHovering)
            Positioned(
              top: 0, // 상단 경계선에 붙이기
              right: 0, // 우측 경계선에 붙이기
              child: GestureDetector(
                onTap: () => widget.onDelete(widget.unitNumber),
                child: Container(
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  padding: const EdgeInsets.all(3),
                  child: const Icon(Icons.close, size: 10, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
