import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moni_pod_web/common_widgets/input_box.dart';
import 'package:moni_pod_web/config/style.dart';
import '../../../common_widgets/button.dart';
import '../../../common_widgets/custom_dialog.dart';
import 'admin_members_screen.dart';

void showEditMemberDialog(BuildContext context, MemberCardData member) {
  showCustomDialog(
    context: context,
    title: 'Member Detail',
    content: SizedBox(width: 680, height: 320, child: EditMemberDialog(member: member)),
  );
}

class EditMemberDialog extends StatefulWidget {
  const EditMemberDialog({required this.member, super.key});

  final MemberCardData member;

  @override
  State<EditMemberDialog> createState() => _EditMemberDialogState();
}

class _EditMemberDialogState extends State<EditMemberDialog> {
  bool _isEditing = true;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    // 초기값 설정
    _nameController = TextEditingController(text: widget.member.name);
    _emailController = TextEditingController(text: widget.member.accountEmail);
    _phoneController = TextEditingController(text: widget.member.phoneNumber);
    _regionController = TextEditingController(text: widget.member.assignedRegion);
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
    return Column(
      children: [
        Container(height: 4, color: themeYellow),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildInfoField('Account', _emailController, _isEditing),
                const SizedBox(height: 28),
                _buildInfoField('Phone', _phoneController, _isEditing),
                const SizedBox(height: 28),
                _buildInfoField('Assignments', _regionController, _isEditing),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(right: 24, bottom: 24),
          alignment: Alignment.bottomRight,
          child: addButton('Send Invite', () {}, imageWidget: Container()),
        ),
      ],
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller, bool isEditable) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 24, child: Text(label, style: titleCommon(commonBlack))),
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
                icon: Padding(
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
