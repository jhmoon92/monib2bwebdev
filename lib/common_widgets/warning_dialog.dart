import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';

void showWarningDialog(BuildContext context, VoidCallback onTap, String contentText) {
  showDialog(context: context, builder: (context) => CommonWarningDialog(onTap: onTap, contentText: contentText));
}

class CommonWarningDialog extends StatefulWidget {
  const CommonWarningDialog({required this.onTap, required this.contentText, super.key});

  final VoidCallback onTap;
  final String contentText;

  @override
  State<CommonWarningDialog> createState() => _CommonWarningDialogState();
}

class _CommonWarningDialogState extends State<CommonWarningDialog> {
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
                SvgPicture.asset("assets/images/ic_32_warning.svg", width: 24, fit: BoxFit.fitWidth),
                const SizedBox(width: 8),
                Text('Warning', style: titleLarge(commonBlack)),
              ],
            ),
            const SizedBox(height: 24),
            Text(widget.contentText, style: deleteCommon(commonBlack)),
            const Spacer(),
            Row(
              children: [
                Expanded(child: SizedBox()),
                InkWell(
                  onTap: () {
                    widget.onTap();
                    context.pop();
                  },
                  child: Container(
                    height: 40,
                    width: 186,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                    child: Text('Done', style: bodyTitle(commonWhite)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
