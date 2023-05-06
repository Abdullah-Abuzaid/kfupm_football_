import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kfupm_football/app/tournament/views/tournament_view.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';

import '../../../core/alert_dialogs/alert_dialog_box.dart';
import '../../../core/animation/bounce_button.dart';
import '../../../core/animation/constant/color.dart';

class TournamentCardWidget extends StatefulWidget {
  Tournament tournament;
  TournamentCardWidget({
    Key? key,
    required this.tournament,
  }) : super(key: key);

  @override
  State<TournamentCardWidget> createState() => _TournamentCardWidgetState();
}

class _TournamentCardWidgetState extends State<TournamentCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kCyanDark,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 350,
      height: 270,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                "Tournament: ${widget.tournament.name}",
                style: t1,
              ),
            ],
          ),
          Column(
            children: [
              Text(
                "Made By: ${widget.tournament.madeBy!.name!.firstName}",
                style: t1,
              ),
              Text(
                "Prize Pool: ${widget.tournament.prizePool}",
                style: t1,
              ),
              Text(
                "Starts: ${DateFormat().add_yMd().format(widget.tournament.startDate)}",
                style: t1,
              ),
              Text(
                "Ends: ${DateFormat().add_yMd().format(widget.tournament.endDate)}",
                style: t1,
              ),
            ],
          ),
          RoundedButton(
            title: "View",
            onTap: () async {
              pushPage(context, TournamentView(tournament: widget.tournament));
            },
          )
        ],
      ),
    );
  }
}
