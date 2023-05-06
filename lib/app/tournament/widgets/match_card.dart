// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kfupm_football/app/tournament/widgets/match_view_popup.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/models/tournament_team_model.dart';

class TournamentMatchCard extends StatefulWidget {
  TournamentMatch match;
  List<TournamentTeam> teams;
  Tournament tournament;
  TournamentMatchCard({
    Key? key,
    required this.tournament,
    required this.match,
    required this.teams,
  }) : super(key: key);

  @override
  State<TournamentMatchCard> createState() => _TournamentMatchCardState();
}

class _TournamentMatchCardState extends State<TournamentMatchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kCyanDark),
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          Text(
            widget.match.participantTeams![0].team!.name +
                " ${widget.match.participantTeams![0].getGoals()} " +
                "vs" +
                " ${widget.match.participantTeams![1].getGoals()} " +
                (widget.match.participantTeams![1].team!.name),
            style: t1,
          ),
          SizedBox(
            height: 10,
          ),
          Text("${widget.match.startDate}"),
          SizedBox(
            height: 10,
          ),
          RoundedButton(
            title: "View",
            onTap: () async {
              AlertDialogBox.showCustomDialog(
                  context: context,
                  widget: MatchViewPopup(
                    tournament: widget.tournament,
                    match: widget.match,
                  ));
            },
          )
        ],
      ),
    );
  }
}
