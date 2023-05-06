// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/app/tournament/widgets/add_match_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/add_team_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/match_card.dart';
import 'package:kfupm_football/app/tournament/widgets/team_match_card.dart';
import 'package:kfupm_football/app/tournament/widgets/tournament_team_card.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import '../../../core/constants/text_styles.dart';
import '../../../core/models/tournament_model.dart';

class TournamentView extends ConsumerStatefulWidget {
  Tournament tournament;
  TournamentView({
    required this.tournament,
  });

  @override
  ConsumerState<TournamentView> createState() => _TournamentViewState();
}

class _TournamentViewState extends ConsumerState<TournamentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          RoundedButton(
            title: "Add Team",
            onTap: () async {
              await AlertDialogBox.showCustomDialog(
                  context: context, widget: AddTeamToTournamentPopup(tournament: widget.tournament));
              ref.invalidate(fetchTournaments);
            },
          ),
          RoundedButton(
            title: "Add Match",
            onTap: () async {
              await AlertDialogBox.showCustomDialog(
                  context: context, widget: CreateTournamentMatchPopup(tournament: widget.tournament));
              ref.invalidate(fetchTournaments);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(),
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
                        child: Text('Made By', style: t1),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text('Prize Pool', style: t1),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text('Starts At', style: t1),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text('Ends At', style: t1),
                      )
                    ]),
                  ]),
                  TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(widget.tournament.name, style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(widget.tournament.madeBy!.name!.firstName, style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(widget.tournament.prizePool.toString(), style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(DateFormat().add_yMd().format(widget.tournament.startDate), style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(DateFormat().add_yMd().format(widget.tournament.endDate), style: t2),
                      )
                    ]),
                  ])
                ],
              ),
              Column(
                children: [
                  Text(
                    "Teams",
                    style: h1,
                  ),
                  if (widget.tournament.teams != null)
                    ...widget.tournament.teams!.map((e) => TournamentTeamCard(team: e)).toList(),
                  if (widget.tournament.plannedMatches != null &&
                      widget.tournament.plannedMatches!.isNotEmpty &&
                      widget.tournament.teams != null)
                    ...widget.tournament.plannedMatches!
                        .map((e) => TournamentMatchCard(
                              tournament: widget.tournament,
                              match: e,
                              teams: widget.tournament.teams!
                                  .where((element) =>
                                      widget.tournament.teams!.map((e) => e.team.id).contains(element.team.id))
                                  .toList(),
                            ))
                        .toList(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
