// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/app/tournament/widgets/add_match_popup.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/drop_menu/drop_down_menu.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:kfupm_football/core/models/shot_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';

import '../../../core/textfields/textfields.dart';
import '../providers/tournament_provider.dart';

class AddGoalPopup extends ConsumerStatefulWidget {
  TournamentMatch match;
  AddGoalPopup({
    Key? key,
    required this.match,
  }) : super(key: key);

  @override
  ConsumerState<AddGoalPopup> createState() => _AddGoalPopupState();
}

class _AddGoalPopupState extends ConsumerState<AddGoalPopup> {
  MatchTeam? forTeam;
  MatchTeam? againstTeam;
  MatchPlayer? shotBy;
  MatchPlayer? assistedBy;
  MatchPlayer? goalie;
  DateTime? dateTime;
  num? distance;
  ShotType? type;
  bool isGoal = false;
  bool isValidShot() {
    return forTeam != null &&
        againstTeam != null &&
        shotBy != null &&
        assistedBy != null &&
        goalie != null &&
        dateTime != null &&
        distance != null &&
        type != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Add a Shot",
          style: t1,
        ),
        SizedBox(height: 20),
        DropDownMenu(
          actualList: ShotType.values,
          items: ShotType.values.map((e) => e.name).toList(),
          hint: "Shot Type",
          onSelect: (value) {
            type = value;
            setState(() {});
          },
        ),
        SizedBox(height: 20),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Distance From Goal ",
          onChange: (value) {
            this.distance = num.tryParse(value ?? "");
          },
        ),
        SizedBox(height: 20),
        DropDownMenu(
          actualList: widget.match.participantTeams!,
          items: widget.match.participantTeams!.map((e) => e.team!.name).toList(),
          hint: "For Team",
          onSelect: (value) {
            forTeam = value;
            againstTeam = widget.match.participantTeams!.firstWhere(
              (element) => element.team!.id != forTeam!.team!.id,
            );
            setState(() {});
          },
        ),
        SizedBox(height: 20),
        if (forTeam != null) ...[
          DropDownMenu(
            actualList: forTeam!.players,
            items: forTeam!.players!.map((e) => e.member!.name!.firstName).toList(),
            hint: "Shot By",
            onSelect: (value) {
              shotBy = value;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          DropDownMenu(
            actualList: forTeam!.players,
            items: forTeam!.players!.map((e) => e.member!.name!.firstName).toList(),
            hint: "Assisted By (optional)",
            onSelect: (value) {
              assistedBy = value;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          DropDownMenu(
            actualList: againstTeam!.players,
            items: againstTeam!.players!.map((e) => e.member!.name!.firstName).toList(),
            hint: "Goalie ",
            onSelect: (value) {
              goalie = value;
              setState(() {});
            },
          ),
          RoundedButton(
            title: "Pick Time",
            onTap: () async {
              dateTime = await showDateTimePicker(context: context);
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text(
                "Was it a Goal",
                style: t1,
              ),
              SizedBox(
                height: 20,
              ),
              Checkbox(
                  value: isGoal,
                  onChanged: (value) {
                    isGoal = value ?? false;
                    setState(() {});
                  }),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                title: "Submit",
                onTap: () async {
                  if (isValidShot()) {
                    await TournamentServices.insertShot(
                      Shot(
                        tournamentID: widget.match.tournamentId,
                        matchID: widget.match.id,
                        distanceFromGoal: distance!,
                        time: dateTime!,
                        forTeam: forTeam!.team!,
                        againstTeam: againstTeam!.team,
                        assistedBy: assistedBy?.member,
                        shotOnGoalie: goalie?.member,
                        type: type,
                        isGoal: isGoal,
                        shotby: shotBy!.member,
                      ),
                    );

                    await popPage(context);
                  }
                },
              ),
              RoundedButton(
                title: "Cancel",
                onTap: () async {
                  popPage(context);
                },
              ),
            ],
          ),
        ]
      ],
    );
  }
}
