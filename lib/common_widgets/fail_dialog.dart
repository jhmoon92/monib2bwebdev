import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moni_pod_web/config/style.dart';

void showFailDialog(BuildContext context, String titleText, String contentText, VoidCallback onTry) {
  showDialog(context: context, builder: (context) => CommonFailDialog(contentText: contentText, onTry: onTry, titleText: titleText));
}

class CommonFailDialog extends StatefulWidget {
  const CommonFailDialog({required this.titleText, required this.contentText, required this.onTry, super.key});

  final String titleText;
  final String contentText;
  final VoidCallback onTry;

  @override
  State<CommonFailDialog> createState() => _CommonFailDialogState();
}

class _CommonFailDialogState extends State<CommonFailDialog> {
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
                SvgPicture.asset("assets/images/ic_24_important.svg", width: 24, fit: BoxFit.fitWidth),
                const SizedBox(width: 8),
                Text(widget.titleText, style: titleLarge(commonBlack)),
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
                    widget.onTry();
                    context.pop();
                  },
                  child: Container(
                    height: 40,
                    width: 186,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: themeYellow, borderRadius: BorderRadius.circular(4)),
                    child: Text('Retry', style: bodyTitle(commonWhite)),
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
