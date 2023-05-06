// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kfupm_football/app/teams/views/team_view.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/models/field_model.dart';

import '../../../core/models/team_model.dart';

class FieldCard extends StatefulWidget {
  Field field;
  FieldCard({
    Key? key,
    required this.field,
  }) : super(key: key);

  @override
  State<FieldCard> createState() => _FieldCardState();
}

class _FieldCardState extends State<FieldCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kTeal,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 350,
      height: 270,
      child: Column(
        children: [
          Text("Name: ${widget.field.name}"),
          SizedBox(
            height: 20,
          ),
          Text("Crowd Size: ${widget.field.crowdSize}"),
          SizedBox(
            height: 20,
          ),
          Text("Sized: ${widget.field.width} X ${widget.field.length}"),
          SizedBox(
            height: 20,
          ),
          Text("Building: ${widget.field.building}"),
          SizedBox(
            height: 20,
          ),
          Text("Room: ${widget.field.room}"),
        ],
      ),
    );
  }
}
