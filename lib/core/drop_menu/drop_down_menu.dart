import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animation/constant/color.dart';
import '../constants/text_styles.dart';

class DropDownMenu extends StatefulWidget {
  final List<String?> items;
  final List<dynamic>? actualList;
  final String hint;
  final ValueSetter<dynamic> onSelect;
  final String? title;
  final String? initialValue;
  final bool matchTextField;
  final bool isMenu;
  final double width;
  const DropDownMenu(
      {Key? key,
      this.width = 300,
      required this.items,
      required this.hint,
      required this.onSelect,
      this.actualList,
      this.initialValue,
      this.title,
      this.isMenu = true,
      this.matchTextField = false})
      : super(key: key);
  @override
  _DropDownMenuState createState() => _DropDownMenuState();
}

class _DropDownMenuState extends State<DropDownMenu> {
  String? _selectedItem;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: kCyan,
      ),
      child: Padding(
        padding: widget.isMenu ? const EdgeInsets.symmetric(horizontal: 20) : const EdgeInsets.symmetric(horizontal: 0),
        child: DropdownButton<String>(
            dropdownColor: kCyan,
            borderRadius: BorderRadius.circular(10),
            menuMaxHeight: 300,
            // alignment: Alignment.centerLeft,
            icon: widget.isMenu
                ? Icon(
                    CupertinoIcons.chevron_down,
                    // color: k,
                  )
                : Icon(
                    Icons.check_box_outline_blank_sharp,
                    color: kBackground,
                    size: 1,
                  ),
            // dropdownColor: kDark1,
            isExpanded: widget.isMenu,
            value: (widget.items.contains(widget.initialValue) && _selectedItem == null) ? widget.initialValue : null,
            underline: SizedBox(),
            items: widget.items.map((String? val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(
                  val!,
                  style: t1,
                ),
              );
            }).toList(),
            hint: Text(
              _selectedItem ?? widget.hint,
              style: t1,
            ),
            onChanged: (newVal) {
              if (widget.isMenu) _selectedItem = newVal;
              if ((widget.actualList)?.isNotEmpty ?? false) {
                widget.onSelect(widget.actualList![widget.items.indexOf(newVal)]);
              } else {
                widget.onSelect(newVal);
              }
              this.setState(() {});
            }),
      ),
    );
  }
}
