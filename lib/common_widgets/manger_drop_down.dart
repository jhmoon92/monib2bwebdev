import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../config/style.dart';
import '../features/manage_building/domain/unit_model.dart';

class MangerDropDown extends StatefulWidget {
  const MangerDropDown({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  final ValueChanged<String> onChanged;
  final String? initialValue;

  @override
  State<MangerDropDown> createState() => _MangerDropDownState();
}

class _MangerDropDownState extends State<MangerDropDown> {
  String? selectedValue = 'Master Admin (admin)';
  final GlobalKey _dropdownKey = GlobalKey();
  double _buttonHeight = 0;
  double _buttonWidth = 0;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? 'Master Admin (admin)';
    WidgetsBinding.instance.addPostFrameCallback((_) => _getButtonSize());
  }

  void _getButtonSize() {
    final RenderBox? renderBox = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      setState(() {
        _buttonHeight = renderBox.size.height;
        _buttonWidth = renderBox.size.width;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 360, child: _buildCustomDropdown());
  }

  Widget _buildCustomDropdown() {
    return PopupMenuButton<String>(
      offset: Offset(0, _buttonHeight),
      constraints: BoxConstraints(minWidth: _buttonWidth),
      surfaceTintColor: Colors.white,
      color: Colors.white,
      child: Container(
        key: _dropdownKey,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: commonGrey5), borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(Icons.person_outline,color: commonGrey7,size: 20),
                  const SizedBox(width: 4),
                  Text(selectedValue ?? 'Select Item', style: TextStyle(fontSize: 16, color: commonBlack)),
                ],
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: commonBlack),
          ],
        ),
      ),

      itemBuilder: (BuildContext context) {
        List<String> items = uniqueManagersList.map((manager) => manager.name).toList();
        items.insert(0, 'Master Admin (admin)');
        return items.map((String item) {
          final bool isSelected = item == selectedValue;

          return PopupMenuItem<String>(
            value: item,
            padding: EdgeInsets.zero,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: isSelected ? themeYellow : Colors.white,
              child: Row(
                children: [
                  Icon(Icons.person_outline,color: commonGrey7,size: 20),
                  const SizedBox(width: 4),
                  Text(item, style: TextStyle(fontSize: 16, color: isSelected ? Colors.white : commonBlack)),
                ],
              ),
            ),
          );
        }).toList();
      },

      onSelected: (String newValue) {
        setState(() {
          selectedValue = newValue;
        });
        widget.onChanged(newValue);
      },
    );
  }
}
