import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';

import 'input_box.dart';

Future<void> showDeleteDialog(BuildContext context, {required String name, required VoidCallback onDelete}) async {
  showDialog(context: context, builder: (context) => CommonDeleteDialog(onDelete: onDelete, name: name));
}

class CommonDeleteDialog extends StatefulWidget {
  final String name;
  final VoidCallback onDelete;

  const CommonDeleteDialog({super.key, required this.name, required this.onDelete});

  @override
  State<CommonDeleteDialog> createState() => _CommonDeleteDialogState();
}

class _CommonDeleteDialogState extends State<CommonDeleteDialog> {
  int _currentIndex = 0;
  String temString = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: commonWhite,
      child: Container(
        width: 432,
        height: 288,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset("assets/images/ic_24_important.svg"),
                const SizedBox(width: 8),
                Text('Delete', style: titleLarge(commonBlack)),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: IndexedStack(index: _currentIndex, children: [step1Screen(), step2Screen()])),
          ],
        ),
      ),
    );
  }

  Widget step1Screen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Are you sure to delete This?', style: titleSmall(commonBlack)),
        const SizedBox(height: 12),
        Text('If you delete this, all associated data will be permanently removed.', style: deleteCommon(commonBlack)),
        const Spacer(),
        Row(
          children: [
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Container(
                height: 40,
                width: 186,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                child: Text('Delete', style: bodyTitle(commonWhite)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget step2Screen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Check Deleting', style: titleSmall(commonBlack)),
        const SizedBox(height: 12),
        Text('Enter ${widget.name} you set before', style: deleteCommon(commonBlack)),
        const SizedBox(height: 12),
        InputBox(
          label: 'Enter the name',
          maxLength: 32,
          isErrorText: true,
          onSaved: (val) {},
          textStyle: bodyCommon(commonBlack),
          textType: 'normal',
          validator: (value) {
            return null;
          },
          onChanged: (value) {
            setState(() {
              temString = value;
            });
          },
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(child: SizedBox()),
            InkWell(
              onTap: () {
                if (temString == widget.name) {
                  widget.onDelete();
                  context.pop();
                }
              },
              child: Container(
                height: 40,
                width: 186,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: temString != widget.name ? commonGrey5 : themeYellow,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('OK', style: bodyTitle(temString != widget.name ? commonGrey6 : commonWhite)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
