// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SideMenuButton {
  final Widget icon;
  final Function() onTap;
  final String title;
  final bool activeColor;

  SideMenuButton({
    Key? key,
    this.activeColor = true,
    required this.icon,
    required this.onTap,
    required this.title,
  });
}
