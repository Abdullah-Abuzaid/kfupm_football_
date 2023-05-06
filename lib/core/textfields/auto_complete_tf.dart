import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../animation/constant/color.dart';
import '../constants/text_styles.dart';
import 'textfields.dart';

class AheadRoundedTextField<T> extends StatefulWidget {
  final String hint;
  final String label;
  final String? initalValue;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final Color? borderColor;
  TextEditingController? controller;
  final String? Function(String?)? validator;
  final Function(String?)? onChange;
  final int minLines;
  final int maxLines;
  final String noItemMessage;
  List<String>? suggestions;
  FutureOr<Iterable<T>> Function(String) suggestionsCallback;
  Widget Function(BuildContext, T?) itemBuilder;
  Function(T?) onSuggestionSelected;
  AheadRoundedTextField(
      {Key? key,
      this.noItemMessage = "No Items Found",
      required this.suggestionsCallback,
      required this.onSuggestionSelected,
      required this.itemBuilder,
      this.hint = "",
      this.borderColor,
      required this.label,
      this.hintStyle = t1,
      this.labelStyle = t1,
      this.controller,
      this.validator,
      this.suggestions,
      this.onChange,
      this.initalValue = null,
      this.minLines = 1,
      this.maxLines = 1})
      : super(key: key) {
    controller ??= TextEditingController();
  }

  @override
  State<AheadRoundedTextField<T>> createState() => _AheadRoundedTextFieldState<T>();
}

class _AheadRoundedTextFieldState<T> extends State<AheadRoundedTextField<T>> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300, maxHeight: 100),
      child: TypeAheadFormField<T>(
        noItemsFoundBuilder: (context) {
          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 50),
            child: Center(
              child: Text(
                widget.noItemMessage,
                style: t1,
              ),
            ),
          );
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
            borderRadius: BorderRadius.circular(10), constraints: const BoxConstraints(maxHeight: 300), color: kCyan),
        getImmediateSuggestions: true,
        suggestionsCallback: widget.suggestionsCallback,
        itemBuilder: widget.itemBuilder,
        onSuggestionSelected: widget.onSuggestionSelected,
        validator: widget.validator,
        initialValue: widget.initalValue,
        textFieldConfiguration: TextFieldConfiguration(
          style: t1,
          controller: widget.controller,
          decoration: InputDecoration(
            suffixIcon: CopyIcon(text: widget.controller!.text),
            hintText: widget.hint,
            hintStyle: widget.hintStyle,
            label: Text(
              widget.label,
              style: t1,
            ),
            floatingLabelStyle: t1,
            labelStyle: widget.labelStyle,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: widget.borderColor ?? kCyan, width: 2),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: kAmber, width: 2), borderRadius: BorderRadius.circular(15)),
          ),
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          onChanged: (value) {
            if (widget.onChange != null) {
              widget.onChange!(value);
              setState(() {});
            }
            setState(() {});
          },
        ),
      ),
    );
  }
}
