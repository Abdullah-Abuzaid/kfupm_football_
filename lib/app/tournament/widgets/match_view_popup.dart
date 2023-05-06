// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/app/tournament/widgets/add_card_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/add_goal_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/make_subsitution_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/team_match_card.dart';
import 'package:kfupm_football/app/tournament/widgets/tournament_team_card.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';

import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';

import '../../../core/animation/bounce_button.dart';

class MatchViewPopup extends ConsumerStatefulWidget {
  Tournament tournament;
  TournamentMatch match;
  MatchViewPopup({
    Key? key,
    required this.tournament,
    required this.match,
  }) : super(key: key);

  @override
  ConsumerState<MatchViewPopup> createState() => _MatchViewPopupState();
}

class _MatchViewPopupState extends ConsumerState<MatchViewPopup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            RoundedButton(
              title: "Add a Goal",
              onTap: () async {
                await AlertDialogBox.showCustomDialog(context: context, widget: AddGoalPopup(match: widget.match));
                ref.invalidate(fetchTournaments);
                popPage(context);
              },
            ),
            RoundedButton(
              title: "Give Player Card",
              onTap: () async {
                await AlertDialogBox.showCustomDialog(
                    context: context, widget: AddTournamentCardPopup(match: widget.match));
                ref.invalidate(fetchTournaments);
                popPage(context);
              },
            ),
            RoundedButton(
              title: "Make Player Substitution",
              onTap: () async {
                await AlertDialogBox.showCustomDialog(
                    context: context, widget: MakeSubsitutionPopup(tournament: widget.tournament, match: widget.match));
                ref.invalidate(fetchTournaments);

                await popPage(context);
              },
            ),
          ],
        ),
        ...widget.match.participantTeams!.map((e) => TeamMatchCard(team: e)).toList(),
        Text(
          "Substitutions",
          style: h1,
        ),
        ...ref.watch(fetchMatchSubstitutions(widget.match.id!)).when(
              data: (data) {
                if (data.isEmpty)
                  return [
                    Text(
                      "No Substitutions",
                      style: t1,
                    )
                  ];

                return data.map((e) {
                  final forTeam = widget.match.participantTeams!.firstWhere((element) => element.team!.id == e.team_id);
                  final playerin =
                      forTeam.players!.firstWhere((element) => e.playerjoining == element.member!.kfupmId!);
                  final playerout =
                      forTeam.players!.firstWhere((element) => e.playerleaving == element.member!.kfupmId!);
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: kCyanDark,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Text(
                        "${playerout.member!.name!.firstName} ==> ${playerin.member!.name!.firstName}\n@${DateFormat.MEd().add_jm().format(e.happenedat)}"),
                  );
                }).toList();
              },
              error: (error, stackTrace) => [
                Center(
                  child: Text(error.toString()),
                )
              ],
              loading: () => [
                Center(
                  child: CircularProgressIndicator(),
                )
              ],
            ),
      ],
    );
  }
}
