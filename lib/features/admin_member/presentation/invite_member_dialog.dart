import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/async_value_widget.dart';
import 'package:moni_pod_web/common_widgets/success_dialog.dart';
import 'package:moni_pod_web/common_widgets/warning_dialog.dart';
import '../../../common/provider/sensing/building_resp.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import '../../../common_widgets/input_box.dart';
import '../../../config/style.dart';
import '../../manage_building/application/buildings_view_model.dart';
import '../../manage_building/domain/unit_model.dart';
import '../data/member_repository.dart';
import '../domain/member_model.dart';

void showInviteMemberDialog(BuildContext context) {
  showCustomDialog(context: context, title: 'Invite Member', content: InviteMemberDialog());
}

class InviteMemberDialog extends ConsumerStatefulWidget {
  const InviteMemberDialog({super.key});

  @override
  ConsumerState<InviteMemberDialog> createState() => _InviteMemberDialogState();
}

class _InviteMemberDialogState extends ConsumerState<InviteMemberDialog> {
  final String selectedSubRole = 'Manager';
  bool isManager = true;
  String assignGroup = "";
  String selectRole = '';
  List<BuildingServer> assignedBuildings = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController bornController = TextEditingController();

  Widget _buildRadioOption({
    required String label,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio<String>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged, // 상태 관리 로직 필요
            activeColor: Colors.blue,
          ),
          Text(label),
        ],
      ),
    );
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
        return Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 680,
            height: selectRole == 'Resident' ? 580 : 620,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 4, color: themeYellow),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text('Send an invitation to a new administrator.', style: bodyTitle(commonGrey6)),
                        const SizedBox(height: 24),
                        _buildInputField(context, 'Name', 'Enter Name', nameController),
                        const SizedBox(height: 28),
                        _buildInputField(context, 'E-mail', 'Enter E-mail', emailController),
                        const SizedBox(height: 28),
                        _buildInputField(context, 'Phone Number', 'Enter Phone Number', phoneNumberController),
                        const SizedBox(height: 28),
                        _buildDropdown('Select Role', 'Select Role', memberRole),
                        const SizedBox(height: 28),
                        selectRole == 'Resident'
                            ? Column(
                              children: [
                                _buildInputField(context, 'Born', 'Enter Born date', bornController),
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
                  child: addButton('Send Invite', () {
                    memberInvite();
                  }, imageWidget: Container()),
                ),
              ],
            ),
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
              SizedBox(
                height: 160, // 리스트의 고정 높이 지정
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
                        shrinkWrap: true, // 추가: 자식들의 높이 합만큼만 크기를 가짐
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
                                title: Text(building.name, style: bodyCommon(commonBlack)),
                                value: isChecked, // 비활성화 항목은 체크 고정
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    if (newValue == true) {
                                      // 중복 체크 후 추가
                                      if (!assignedBuildings.any((item) => item.id == building.id)) {
                                        assignedBuildings.add(BuildingServer(
                                          id: building.id,
                                          name: building.name,
                                        ));
                                      }
                                    } else {
                                      // 삭제 로직
                                      assignedBuildings.removeWhere((item) => item.id == building.id);
                                    }
                                  });
                                  print('Selected: ${assignedBuildings.map((e) => e.name).toList()}');
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

  Widget _buildInputField(BuildContext context, String label, String hint, TextEditingController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          child: InputBox(
            controller: controller,
            label: hint,
            maxLength: 32,
            isErrorText: true,
            onSaved: (val) {},
            textStyle: bodyCommon(commonBlack),
            textType: 'normal',
            validator: (value) {
              return null;
            },
            icon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgPicture.asset(
                label == 'Name'
                    ? 'assets/images/ic_24_person.svg'
                    : label == 'E-mail'
                    ? 'assets/images/ic_24_mail.svg'
                    : 'assets/images/ic_24_call.svg',
                width: 16,
                fit: BoxFit.fitWidth,
                colorFilter: ColorFilter.mode(commonGrey5, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> memberInvite() async {
    try {
      await ref
          .read(memberRepositoryProvider)
          .memberInvite(emailController.text, nameController.text, phoneNumberController.text, isManager ? 20 : 50);

      if (context.mounted) {
        Navigator.of(context).pop();
        showSuccessDialog(context, 'Invitations sent successfully.');
      }
    } on Exception catch (e) {
      if (context.mounted) {
        String errorMessage = 'An error occurred.';
        if (e is DioException) {
          if (e.response?.statusCode == 400) {
            errorMessage = 'This email address is already registered.';
          } else {
            errorMessage = 'Server error: ${e.response?.statusCode}';
          }
        }

        showWarningDialog(context, (){},errorMessage);
      }
    }
  }
}
