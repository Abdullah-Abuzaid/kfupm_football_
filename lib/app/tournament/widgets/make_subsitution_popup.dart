// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/app/tournament/widgets/add_match_popup.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';

import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/drop_menu/drop_down_menu.dart';
import 'package:kfupm_football/core/models/field_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:kfupm_football/core/models/shot_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';

import '../../../core/models/tournament_model.dart';
import '../../../core/textfields/textfields.dart';

class MakeSubsitutionPopup extends StatefulWidget {
  TournamentMatch match;
  Tournament tournament;
  MakeSubsitutionPopup({
    Key? key,
    required this.tournament,
    required this.match,
  }) : super(key: key);

  @override
  State<MakeSubsitutionPopup> createState() => _MakeSubsitutionPopupState();
}

class _MakeSubsitutionPopupState extends State<MakeSubsitutionPopup> {
  MatchTeam? forTeam;

  MatchPlayer? leavingPlayer;

  DateTime? dateTime;
  KFUPMMemeber? joiningPlayer;
  FieldType? fieldType;

  bool isValidShot() {
    return forTeam != null && joiningPlayer != null && leavingPlayer != null && fieldType != null && dateTime != null;
  }

  List<KFUPMMemeber> teamPlayers() {
    if (forTeam == null) return [];
    final tournamentTeam = widget.tournament.teams!.firstWhere((element) => element.team.id == forTeam!.team!.id);

    final selectedTeam = widget.match.participantTeams!.firstWhere((element) => element.team!.id == forTeam!.team!.id);
    final matchPlayers = selectedTeam.players!.map((e) => e.member!.kfupmId);

    print(tournamentTeam.players.length);

    return tournamentTeam.players
        .where((e) => !matchPlayers.contains(e.memeber.kfupmId))
        .map((e) => e.memeber)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Make a Subsitution",
          style: t1,
        ),
        SizedBox(height: 20),
        DropDownMenu(
          actualList: widget.match.participantTeams!,
          items: widget.match.participantTeams!.map((e) => e.team!.name).toList(),
          hint: "For Team",
          onSelect: (value) {
            forTeam = value;

            setState(() {});
          },
        ),
        SizedBox(height: 20),
        if (forTeam != null) ...[
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kCyanDark),
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                DropDownMenu(
                  actualList: teamPlayers()!,
                  items: teamPlayers().map((e) => e.name!.firstName).toList(),
                  hint: "Joining Player",
                  onSelect: (value) {
                    joiningPlayer = value;
                    setState(() {});
                  },
                ),
                SizedBox(height: 20),
                DropDownMenu(
                  actualList: FieldType.values,
                  items: FieldType.values.map((e) => e.name).toList(),
                  hint: "Field Type",
                  onSelect: (value) {
                    fieldType = value;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          DropDownMenu(
            actualList: forTeam!.players,
            items: forTeam!.players!.map((e) => e.member!.name!.firstName).toList(),
            hint: "Replacing Player",
            onSelect: (value) {
              leavingPlayer = value;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          RoundedButton(
            title: "Pick Time",
            onTap: () async {
              dateTime = await showDateTimePicker(context: context);
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                title: "Submit",
                onTap: () async {
                  if (isValidShot()) {
                    await TournamentServices.makePlayerSubstitution(
                      playerIn: MatchPlayer(
                        matchId: widget.match.id!,
                        ismvp: false,
                        team: forTeam!.team!.id,
                        member: joiningPlayer,
                        startat: dateTime,
                        fieldType: fieldType,
                      ),
                      playerOut: leavingPlayer!,
                      teamID: forTeam!.team!.id,
                      happenendAt: dateTime!,
                      matchID: widget.match.id!,
                    );
                    await popPage(context);
                  } else {
                    TopNotification(message: "Fill Every Field", context: context);
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
