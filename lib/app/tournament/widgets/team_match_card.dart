// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import 'package:kfupm_football/core/models/match_team_model.dart';

import '../../../core/animation/constant/color.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/models/card_model.dart';
import '../../teams/widgets/avatar_widget.dart';

class TeamMatchCard extends StatefulWidget {
  MatchTeam team;
  TeamMatchCard({
    Key? key,
    required this.team,
  }) : super(key: key);

  @override
  State<TeamMatchCard> createState() => _TeamMatchCardState();
}

class _TeamMatchCardState extends State<TeamMatchCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kCyanDark,
      ),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(4),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              AvatarImage(imgUrl: widget.team.team!.imageUrl!),
              SizedBox(
                width: 60,
              ),
              Text(
                widget.team.team!.name,
                style: t1,
              ),
            ],
          ),
          Table(
            defaultColumnWidth: FixedColumnWidth(220.0),
            border: TableBorder.all(
                color: Colors.teal, style: BorderStyle.solid, width: 4, borderRadius: BorderRadius.circular(10)),
            children: [
              TableRow(children: [
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Name', style: t1),
                  )
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Goals', style: t1),
                  )
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Yellow Cards', style: t1),
                  )
                ]),
                Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Red Cards', style: t1),
                  )
                ]),
              ]),
              ...widget.team.players!.map((e) => TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(e.member!.name!.firstName, style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.shots!.where((element) => element.isGoal!).length.toString()),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.cards!.where((element) => element.type == CardType.yellow).length.toString(),
                            style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.cards!.where((element) => element.type == CardType.red).length.toString(),
                            style: t2),
                      )
                    ]),
                  ]))
            ],
          ),
        ],
      ),
    );
  }
}
