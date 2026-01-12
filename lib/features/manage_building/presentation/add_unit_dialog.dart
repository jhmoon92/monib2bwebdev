import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/async_value_widget.dart';
import 'package:moni_pod_web/common_widgets/fail_dialog.dart';
import 'package:moni_pod_web/features/admin_member/application/member_view_model.dart';
import '../../../common/provider/sensing/building_resp.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../common_widgets/success_dialog.dart';
import '../../../config/style.dart';
import '../application/buildings_view_model.dart';

void showAddUnitDialog(BuildContext context, String buildingId) {
  showCustomDialog(
    context: context,
    title: 'Add Unit',
    content: SizedBox(width: 680, height: 700, child: AddUnitDialog(buildingId: buildingId)),
  );
}

class AddUnitDialog extends ConsumerStatefulWidget {
  const AddUnitDialog({required this.buildingId, super.key});

  final String buildingId;
  @override
  ConsumerState<AddUnitDialog> createState() => _AddUnitDialogState();
}

const String unassignedInstallerId = 'none';

class _AddUnitDialogState extends ConsumerState<AddUnitDialog> with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _buildingNameController = TextEditingController();

  final TextEditingController _unitNumberController = TextEditingController();
  final TextEditingController _residentNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _assignInstallerController = TextEditingController();
  final TextEditingController _deviceNumberController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  double _progressbarValue1 = 0;
  bool isStep1 = true;
  late TabController _tabController;
  late Animation<double> _animation1;
  late AnimationController _controller1;
  int _deviceCount = 1;
  String _selectedInstallerId = unassignedInstallerId;
  String _searchQuery = '';
  List<Member> memberList = [];
  List<Member> residentsList = [];
  List<Member> installerList = [];
  Resident? resident;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, animationDuration: const Duration(milliseconds: 500));
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      reverseDuration: const Duration(seconds: 1),
    );
    _animation1 = CurvedAnimation(parent: _controller1, curve: Curves.easeIn);
    _animation1.addListener(() {
      if (mounted) {
        setState(() {
          _progressbarValue1 = _animation1.value;
        });
      }
    });
  }

  @override
  void dispose() {
    _buildingNameController.dispose();
    _debounce?.cancel();
    _controller1.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    _unitNumberController.dispose();
    _residentNameController.dispose();
    _phoneNumberController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncProviderWidget(
      provider: memberViewModelProvider,
      onTry: () async {
        ref.read(memberViewModelProvider.notifier).fetchData();
      },
      data: (data) {
        memberList = data as List<Member>;
        residentsList = memberList.where((member) => member.authority == 100).toList();
        installerList = memberList.where((member) => member.authority == 50).toList();

        return Form(
          key: _formKey,
          child: Column(
            children: [
              Container(height: 4, color: themeYellow),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우 패딩만 유지
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      inputText('Unit Number', _unitNumberController, isRequired: true),
                      const SizedBox(height: 28),
                      dropdownResident(),
                      const SizedBox(height: 28),
                      // inputText('Resident Name', _residentNameController),
                      // inputText('Phone Number', _phoneNumberController),
                      // const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(flex: 24, child: Text('Number of Devices', style: titleCommon(commonBlack))),
                          Expanded(flex: 44, child: _buildDeviceCounter()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.only(left: 222),
                        child: Text("These devices will be created as 'Offline' placeholders.", style: bodyCommon(commonGrey5)),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 24,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Assign Installer', style: titleCommon(commonBlack)),
                                Text('(Optional)', style: bodyCommon(commonGrey5)),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 44,
                            child: Column(children: [_buildInstallerSearch(), const SizedBox(height: 12), _buildInstallerList()]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 24, bottom: 24),
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () async {
                    if(_unitNumberController.text.isNotEmpty){
                      addUnit();
                    }
                  },
                  child: Container(
                    width: 256,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _unitNumberController.text.isNotEmpty ? themeYellow : commonGrey5,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 4),
                        Text('Add Unit', style: bodyTitle(_unitNumberController.text.isNotEmpty ? commonWhite : commonGrey6)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> addUnit() async {
    try {
      UnitServer unit = UnitServer(
        name: _unitNumberController.text,
        residents: resident != null ? [resident!] : [],
        installer: Installer(id: _selectedInstallerId == unassignedInstallerId ? null : int.parse(_selectedInstallerId), name: null),
        numStations: _deviceCount,
      );
      await ref.read(buildingsViewModelProvider.notifier).addUnit(widget.buildingId, unit);

      if (context.mounted) {
        Navigator.of(context).pop();
        await showSuccessDialog(context, 'New unit is added.');
        ref.read(buildingsViewModelProvider.notifier).fetchData();
      }
    } on Exception catch (e) {
      showFailDialog(context, 'Failed to add unit', 'Something went wrong while saving the building. Please try again.', () {});
    }
  }

  Widget _buildDeviceCounter() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildCounterButton(Icons.remove, () {
          setState(() {
            if (_deviceCount > 1) _deviceCount--;
          });
        }, _deviceCount > 1),
        const SizedBox(width: 16),
        Container(width: 50, alignment: Alignment.center, child: Text('$_deviceCount', style: bodyTitle(commonBlack))),

        // SizedBox(
        //   width: 144,
        //   child: InputBox(
        //     controller: _deviceNumberController,
        //     initialText: _deviceCount.toString(),
        //     maxLength: 32,
        //     isErrorText: true,
        //     onSaved: (val) {},
        //     textStyle: bodyTitle(commonBlack),
        //     textType: 'normal',
        //     validator: (value) {
        //       return null;
        //     },
        //   ),
        // ),
        const SizedBox(width: 16),
        _buildCounterButton(Icons.add, () {
          if (_deviceCount < 4) {
            setState(() {
              _deviceCount++;
            });
          }
        }, _deviceCount < 4),
      ],
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback onPressed, bool isEnabled) {
    return InkWell(
      onTap: isEnabled ? onPressed : null,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: isEnabled ? commonWhite : commonGrey3,
          border: Border.all(color: commonGrey2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 20, color: isEnabled ? commonBlack : commonWhite),
      ),
    );
  }

  Widget _buildInstallerSearch() {
    return InputBox(
      controller: _assignInstallerController,
      label: 'Search Member',
      maxLength: 64,
      isErrorText: true,
      onSaved: (val) {},
      textStyle: bodyCommon(commonBlack),
      textType: 'normal',
      validator: (value) {
        return null;
      },
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
        });
      },
      icon: Padding(padding: const EdgeInsets.only(left: 8), child: SvgPicture.asset('assets/images/ic_16_search.svg')),
    );
  }

  Widget _buildInstallerList() {
    final List<Map<String, dynamic>> installerOptions = _getFilteredInstallerOptions();

    return Container(
      height: 200,
      decoration: BoxDecoration(border: Border.all(color: commonGrey3), borderRadius: BorderRadius.circular(4)),
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
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: installerOptions.length,
            itemBuilder: (context, index) {
              final option = installerOptions[index];
              return _buildInstallerItem(id: option['id']!, name: option['name']!, icon: option['icon']!);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInstallerItem({required String id, required String name, required IconData icon}) {
    final bool isSelected = id == _selectedInstallerId;
    final bool isUnassigned = id == unassignedInstallerId;

    final Color iconColor = isSelected ? themeYellow : commonGrey5;
    final Color textColor = isSelected ? themeYellow : commonBlack;
    final Color tileColor = isSelected && !isUnassigned ? commonGrey1 : Colors.transparent;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedInstallerId = id;
        });
        print(_selectedInstallerId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: tileColor,
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(name, style: isUnassigned ? (isSelected ? bodyTitle(themeYellow) : bodyTitle(commonBlack)) : bodyCommon(textColor)),
          ],
        ),
      ),
    );
  }

  Widget dropdownResident() {
    List<String> residentNames = residentsList.map((member) => member.name).toList();

    return Row(
      children: [
        Expanded(flex: 24, child: Text('Resident Name', style: titleCommon(commonBlack))),
        const SizedBox(height: 4),
        Expanded(
          flex: 44,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: commonGrey2, width: 1.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: commonGrey2, width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: themeYellow, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            hint: Text('Assign Resident', style: bodyCommon(commonGrey7)),
            value: null,
            items:
                residentNames.map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value, style: bodyCommon(commonGrey7)));
                }).toList(),
            onChanged: (String? newValue) {
              int index = residentNames.indexOf(newValue!);
              setState(() {
                resident = Resident(
                  id: residentsList[index].id,
                  name: residentsList[index].name,
                  phoneNumber: residentsList[index].phoneNumber,
                );
              });
            },
          ),
        ),
      ],
    );
  }

  Widget inputText(String title, TextEditingController controller, {bool isRequired = false}) {
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
              InputBox(
                controller: controller,
                label: title,
                maxLength: 32,
                isErrorText: true,
                icon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SvgPicture.asset(
                    title == 'Unit Number'
                        ? 'assets/images/ic_24_room_1.svg'
                        : title == 'Resident Name'
                        ? 'assets/images/ic_24_person.svg'
                        : 'assets/images/ic_24_call.svg',
                    width: 16,
                    fit: BoxFit.fitWidth,
                    colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                  ),
                ),
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

  // 3. 설치자 목록 필터링 함수
  List<Map<String, dynamic>> _getFilteredInstallerOptions() {
    final List<Map<String, dynamic>> allOptions = [
      {'id': unassignedInstallerId, 'name': 'Do not assign yet', 'icon': Icons.person_off_outlined},
      ...installerList.map((i) => {'id': i.id.toString(), 'name': i.name, 'icon': Icons.person_outline}),
    ];

    if (_searchQuery.isEmpty) {
      return allOptions;
    }

    final lowerCaseQuery = _searchQuery.toLowerCase();

    // 'Do not assign yet' 항목을 분리
    final unassignedOption = allOptions.first;

    // 나머지 설치자 목록을 필터링 (이름에 검색어가 포함되는지 확인)
    final filteredInstallers =
        allOptions.sublist(1).where((option) {
          final name = option['name']!.toLowerCase();
          return name.contains(lowerCaseQuery);
        }).toList();

    // 필터링된 목록 앞에 'Do not assign yet'을 다시 추가
    return [unassignedOption, ...filteredInstallers];
  }
}
