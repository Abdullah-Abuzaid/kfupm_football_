// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kfupm_football/app/teams/views/team_view.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';

import '../../../core/models/team_model.dart';

class TeamCard extends StatefulWidget {
  Team team;
  TeamCard({
    Key? key,
    required this.team,
  }) : super(key: key);

  @override
  State<TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<TeamCard> {
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
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.team.imageUrl!),
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text("Team: ${widget.team.name}"),
            ],
          ),
          Column(
            children: [
              Text("Website: ${widget.team.website}"),
              Text("Email: ${widget.team.email}"),
              Text("Managed By: ${widget.team.manager?.name?.firstName ?? ""}"),
              Text("Managed By: ${widget.team.coach?.name?.firstName ?? ""}"),
            ],
          ),
          RoundedButton(
            title: "View",
            onTap: () async {
              AlertDialogBox.showCustomDialog(
                context: context,
                widget: TeamView(team: widget.team),
              );
            },
          )
        ],
      ),
    );
  }
}
