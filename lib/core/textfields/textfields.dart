import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../animation/constant/color.dart';
import '../constants/text_styles.dart';

class RoundedTextField extends StatefulWidget {
  final String hint;
  final String label;
  final bool obsecureText;
  final String? initialValue;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final int minLines;
  final int maxLines;
  final Color? borderColor;
  final bool isDisable;
  final bool expanded;
  final Widget? suffixWidget;
  final double? width;
  TextInputType? textInputType;
  bool noIcon;
  List<TextInputFormatter>? formatter;

  RoundedTextField(
      {Key? key,
      this.width = 300,
      this.obsecureText = false,
      this.noIcon = false,
      this.formatter,
      this.borderColor,
      this.textInputType,
      this.hint = "",
      this.expanded = false,
      this.suffixWidget,
      this.isDisable = false,
      required this.label,
      this.hintStyle = hStyle,
      this.labelStyle = t1,
      this.controller,
      this.validator,
      this.onChange,
      this.initialValue,
      this.minLines = 1,
      this.maxLines = 1})
      : super(key: key);

  @override
  State<RoundedTextField> createState() => _RoundedTextFieldState();
}

class _RoundedTextFieldState extends State<RoundedTextField> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.expanded == null ? double.infinity : widget.width!, maxHeight: 100),
      child: TextFormField(
        obscureText: widget.obsecureText,
        keyboardType: widget.textInputType,
        inputFormatters: widget.formatter,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        initialValue: widget.initialValue,
        onChanged: (value) {
          if (widget.onChange != null) {
            widget.onChange!(value);
            setState(() {});
          }
          setState(() {});
        },
        style: t1,
        validator: widget.validator,
        readOnly: widget.isDisable,
        controller: widget.controller,
        decoration: InputDecoration(
          suffixIcon: widget.suffixWidget ??
              (widget.noIcon ? null : CopyIcon(text: widget.controller?.text ?? widget.initialValue ?? "")),
          hintText: widget.hint,
          hintStyle: widget.hintStyle,
          label: Text(widget.label),
          floatingLabelStyle: t1,
          labelStyle: widget.labelStyle,
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: widget.isDisable ? kWhite : widget.borderColor ?? kCyan, width: 2),
              borderRadius: BorderRadius.circular(15)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: kAmber, width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

class CopyIcon extends StatefulWidget {
  String text;
  CopyIcon({Key? key, required this.text}) : super(key: key);

  @override
  State<CopyIcon> createState() => _CopyIconState();
}

class _CopyIconState extends State<CopyIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print(widget.text);
        await Clipboard.setData(ClipboardData(text: widget.text));
      },
      child: Icon(
        Icons.copy,
        color: kCyan,
        size: 30,
      ),
    );
  }
}
