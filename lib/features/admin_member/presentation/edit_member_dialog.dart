import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common/provider/sensing/building_resp.dart';
import 'package:moni_pod_web/common_widgets/async_value_widget.dart';
import 'package:moni_pod_web/common_widgets/input_box.dart';
import 'package:moni_pod_web/config/style.dart';
import 'package:moni_pod_web/features/manage_building/application/buildings_view_model.dart';
import '../../../common/provider/sensing/member_resp.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/fail_dialog.dart';
import '../../../common_widgets/success_dialog.dart';
import '../../manage_building/domain/unit_model.dart';
import '../application/member_view_model.dart';
import '../domain/member_model.dart';
import 'admin_members_screen.dart';

void showEditMemberDialog(BuildContext context, Member member) {
  showCustomDialog(context: context, title: 'Edit Member', content: EditMemberDialog(member: member));
}

class EditMemberDialog extends ConsumerStatefulWidget {
  const EditMemberDialog({required this.member, super.key});

  final Member member;

  @override
  ConsumerState<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends ConsumerState<EditMemberDialog> {
  bool _isEditing = true;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _bornController;
  late TextEditingController _phoneController;
  late TextEditingController _regionController;
  String assignGroup = '';
  String selectRole = '';
  List<BuildingServer>? assignedBuildings;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.email);
    _bornController = TextEditingController(text: widget.member.phoneNumber);
    _phoneController = TextEditingController(text: widget.member.phoneNumber);
    _regionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncProviderWidget(
      provider: buildingsViewModelProvider,
      onTry: () async {
        ref.read(buildingsViewModelProvider.notifier).fetchData();
      },
      data: (data) {
        List<Building> buildings = data as List<Building>;

        if (assignedBuildings == null) {
          assignedBuildings =
              buildings.where((b) => widget.member.assignedBuildings.contains(b.name)).map((b) => BuildingServer(id: b.id, name: b.name)).toList();
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 680,
          height: selectRole == 'Resident' ? 680 : 610,
          child: Column(
            children: [
              Container(height: 4, color: themeYellow),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Text('Edit member information', style: bodyTitle(commonGrey6)),
                      const SizedBox(height: 24),
                      _buildInfoField('Name', _nameController, _isEditing),
                      const SizedBox(height: 24),
                      _buildInfoField('E-mail', _emailController, _isEditing),
                      const SizedBox(height: 24),
                      _buildInfoField('Phone Number', _phoneController, _isEditing),
                      const SizedBox(height: 28),
                      _buildDropdown(
                        'Select Role',
                        widget.member.authority == 1
                            ? 'Master'
                            : widget.member.authority == 20
                            ? 'Manager'
                            : widget.member.authority == 50
                            ? 'Installer'
                            : 'Resident',
                        memberRole,
                      ),
                      const SizedBox(height: 28),
                      selectRole == 'Resident'
                          ? Column(
                            children: [
                              _buildInfoField('Born', _bornController, _isEditing),
                              const SizedBox(height: 28),
                              _buildDropdown('Gender', 'Select Gender', gender),
                              const SizedBox(height: 28),
                            ],
                          )
                          : assignedGroup(buildings),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(right: 24, bottom: 24),
                alignment: Alignment.bottomRight,
                child: addButton('Save Changes', () async {
                  try {
                    Member updatedMember = widget.member.copyWith(
                      name: _nameController.text,
                      email: _emailController.text,
                      phoneNumber: _phoneController.text,
                      assignedBuildings: assignedBuildings?.map((e) => e.id ?? '').toList() ?? [],
                      authority:
                          selectRole == 'Master'
                              ? 1
                              : selectRole == 'Manager'
                              ? 20
                              : selectRole == 'Installer'
                              ? 50
                              : 100,
                    );
                    await ref.read(memberViewModelProvider.notifier).updateMember(updatedMember);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                      showSuccessDialog(context, 'The ${widget.member.name} is updated.');
                      await ref.read(memberViewModelProvider.notifier).fetchData();
                    }
                  } on Exception catch (e) {
                    showFailDialog(context, 'Failed to add unit', 'Something went wrong while deleting the member. Please try again.', () {
                      Navigator.of(context).pop();
                    });
                  }
                }, imageWidget: Container()),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget assignedGroup(List<Building> assignedBuilding) {
    ScrollController _scrollController = ScrollController();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 24, child: Text('Assign Building', style: titleCommon(commonBlack))),
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
                        itemCount: assignedBuilding.length,
                        itemBuilder: (context, index) {
                          final building = assignedBuilding[index];
                          // ✅ assignedBuildings가 null일 경우 빈 리스트로 처리
                          bool isChecked = assignedBuildings?.any((item) => item.id == building.id) ?? false;

                          return Container(
                            key: ValueKey('building_${building.id}'),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                                key: ValueKey('checkbox_${building.id}'),
                                title: Text(building.name, style: bodyCommon(commonBlack)),
                                value: isChecked, // 비활성화 항목은 체크 고정
                                onChanged: (bool? newValue) {
                                  // 💡 마우스 이벤트 충돌 방지를 위해 미세한 지연을 줄 수도 있습니다.
                                  setState(() {
                                    if (newValue == true) {
                                      if (!(assignedBuildings?.any((item) => item.id == building.id) ?? false)) {
                                        assignedBuildings?.add(BuildingServer(id: building.id, name: building.name));
                                      }
                                    } else {
                                      // ✅ 삭제 로직: ID를 기준으로 정확히 삭제
                                      assignedBuildings?.removeWhere((item) => item.id == building.id);
                                    }
                                  });
                                  print('Selected: ${assignedBuildings?.map((e) => e.name).toList()}');
                                },
                                visualDensity: const VisualDensity(horizontal: 0, vertical: -4), // ✅ 수직 밀도를 최소로 줄임
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0), // ✅ 세로 패딩 제거
                                controlAffinity: ListTileControlAffinity.leading,
                                checkColor: Colors.white,
                                activeColor: themeYellow,
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
  }

  Widget _buildInfoField(String label, TextEditingController controller, bool isEditable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 24,
          child:
              label == 'Phone Number' || label == 'Born'
                  ? Text(label, style: titleCommon(commonBlack))
                  : RichText(
                    text: TextSpan(
                      text: label,
                      style: titleCommon(commonBlack),
                      children: [TextSpan(text: ' *', style: titleCommon(Colors.red))],
                    ),
                  ),
        ),
        Expanded(
          flex: 44,
          child: Stack(
            children: [
              InputBox(
                controller: controller,
                readOnly: !isEditable,
                label: label,
                maxLength: 32,
                isErrorText: true,
                onSaved: (val) {},
                icon:
                    label == 'Born'
                        ? null
                        : Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: SvgPicture.asset(
                            label == 'Account'
                                ? 'assets/images/ic_24_mail.svg'
                                : label == 'Phone'
                                ? 'assets/images/ic_24_call.svg'
                                : 'assets/images/ic_24_location.svg',
                            width: 16,
                            fit: BoxFit.fitWidth,
                            colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
                          ),
                        ),
                textStyle: bodyCommon(commonBlack),
                textType: 'normal',
                validator: (value) {
                  return null;
                },
              ),
              isEditable ? Container() : Positioned.fill(child: Container(color: Colors.transparent)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String guideText, List<String> items) {
    return Row(
      children: [
        Expanded(
          flex: 24,
          child:
              label == 'Select Role'
                  ? RichText(
                    text: TextSpan(
                      text: label,
                      style: titleCommon(commonBlack),
                      children: [TextSpan(text: ' *', style: titleCommon(Colors.red))],
                    ),
                  )
                  : Text(label, style: titleCommon(commonBlack)),
        ),
        const SizedBox(height: 4),
        Expanded(
          flex: 44,
          child: SizedBox(
            height: 44,
            child: DropdownButtonFormField<String>(
              isDense: true, // 1. 내부 요소들을 조밀하게 배치
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
              hint: Text(guideText, style: bodyCommon(commonGrey7)),
              value: null,
              items:
                  items.map((String value) {
                    return DropdownMenuItem<String>(value: value, child: Text(value, style: bodyCommon(commonGrey7)));
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  if (label == 'Select Role') {
                    selectRole = newValue!;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // ⭐️ 저장 로직 (더미)
  void _saveProfile() {
    // 1. 여기서 API를 호출하여 수정된 데이터를 서버에 전송합니다.
    // final updatedData = MemberCardData(
    //   name: _nameController.text,
    //   accountEmail: _emailController.text,
    //   // ... 나머지 필드 ...
    // );

    // 2. 서버 통신 성공 시, GoRouter/Riverpod 등을 이용해 UI 상태를 업데이트합니다.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully!')));
  }
}
