// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';

import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_player_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';

import '../../../core/drop_menu/drop_down_menu.dart';

class ChooseTeamMatchPlayers extends StatefulWidget {
  Tournament tournament;
  String matchId;
  DateTime starttime;
  MatchTeam? otherTeam;
  ChooseTeamMatchPlayers({
    Key? key,
    this.otherTeam,
    required this.tournament,
    required this.matchId,
    required this.starttime,
  }) : super(key: key);

  @override
  State<ChooseTeamMatchPlayers> createState() => _ChooseTeamMatchPlayersState();
}

class _ChooseTeamMatchPlayersState extends State<ChooseTeamMatchPlayers> {
  List<MatchPlayer> players = [];
  TournamentTeam? team;

  isValidTeam() {
    bool isValid = true;

    players.forEach((element) {
      isValid = element.fieldType != null;
    });
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropDownMenu(
            actualList: widget.tournament.teams!.where((e) => e.team.id != (widget.otherTeam?.team?.id ?? "")).toList(),
            items: widget.tournament.teams!
                .where((e) => e.team.id != (widget.otherTeam?.team?.id ?? ""))
                .map((e) => e.team.name)
                .toList(),
            hint: "Choose Team",
            onSelect: (onSelect) {
              team = onSelect;
              setState(() {});
            }),
        Text(
          "Select Players",
          style: t1,
        ),
        SizedBox(
          height: 30,
        ),
        if (team != null) ...[
          Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                ...team!.players.map((e) {
                  return GestureDetector(
                    onTap: () {
                      if (players.length == 11) {
                        TopNotification(message: "Only Put 11 Players as the starting match`", context: context);
                        return;
                      }
                      if (!(players.map((ele) => ele.member!.kfupmId).contains(e.memeber.kfupmId!)))
                        players.add(MatchPlayer(
                          matchId: widget.matchId,
                          startat: widget.starttime,
                          ismvp: false,
                          team: team!.team.id,
                          member: e.memeber,
                        ));
                      else
                        TopNotification(message: "Player Already added", context: context);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(color: kCyanDark, borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.all(10),
                      child: Text(e.memeber.name!.firstName),
                    ),
                  );
                }).toList()
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          SizedBox(
            height: 700,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...players.map((e) => Container(
                        decoration: BoxDecoration(color: kCyanDark, borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            Text(e.member!.name!.firstName),
                            SizedBox(
                              width: 20,
                            ),
                            DropDownMenu(
                              actualList: FieldType.values,
                              items: FieldType.values.map((e) => e.name).toList(),
                              hint: "Choose Player Field Type",
                              onSelect: (value) {
                                e.fieldType = value;

                                setState(() {});
                              },
                            )
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
        SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
                title: "Submit",
                onTap: () {
                  if (team != null && players.length == 11 && isValidTeam())
                    popPage(
                      context,
                      args: MatchTeam(team: team!.team, players: players),
                    );
                  else
                    TopNotification(message: "Please Fill The Requirement", context: context);
                }),
            SizedBox(
              width: 20,
            ),
            RoundedButton(
              title: "Cancel",
              onTap: () => popPage(context),
            ),
          ],
        )
      ],
    );
  }
}
