// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/providers/team_providers.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_animation.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/animation/on_click_bounce.dart';

import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/drop_menu/drop_down_menu.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/progress_dialog/progress_dialog.dart';

import '../../../core/models/team_model.dart';

class AddTeamToTournamentPopup extends ConsumerStatefulWidget {
  Tournament tournament;
  AddTeamToTournamentPopup({
    required this.tournament,
  });

  @override
  ConsumerState<AddTeamToTournamentPopup> createState() => _AddTeamToTournamentPopupState();
}

class _AddTeamToTournamentPopupState extends ConsumerState<AddTeamToTournamentPopup> {
  Team? team;
  List<KFUPMMemeber> players = [];

  bool validTeam() {
    return team != null && players.length >= 11;
  }

  bool playerSelected(String kfupmId) {
    return players.map((e) => e.kfupmId).contains(kfupmId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Register Team In Tournament",
          style: h1,
        ),
        SizedBox(
          height: 50,
        ),
        ref.watch(fetchTeamsProvider).when(
              data: (teams) {
                final teamsIn = widget.tournament.teams ?? [];
                final notInTournaments = teams.where(
                  (team) {
                    if (teamsIn.isEmpty)
                      return true;
                    else
                      return teamsIn.map((e) => e.team.id).contains(team.id);
                  },
                );

                return DropDownMenu(
                  actualList: teams,
                  items: teams.map((e) => e.name).toList(),
                  hint: "Choose a Team",
                  onSelect: (value) {
                    team = value;
                    players = [];
                    setState(() {});
                  },
                );
              },
              error: (e, s) {
                return Center(
                  child: Text(e.toString()),
                );
              },
              loading: () => Center(
                child: CircularProgressIndicator(),
              ),
            ),
        Column(
          children: [
            if (team == null)
              Text(
                "Please Select a Team",
                style: t1,
              ),
            if (team != null && team!.players == null) Text("There are no players in this team"),
            if (team != null && team!.players != null)
              ...team!.players!.map(
                (e) => OnHoverScale(
                  maxScale: 1.01,
                  child: OnClickScale(
                    maxScale: 1.01,
                    onTap: () {
                      if (playerSelected(e.kfupmId!)) {
                        players.removeWhere((element) => element.kfupmId! == e.kfupmId!);
                      } else {
                        players.add(e);
                      }
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      height: 70,
                      duration: Duration(milliseconds: 500),
                      decoration: BoxDecoration(
                        color: kCyanDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: playerSelected(e.kfupmId!) ? kAmber : Colors.transparent),
                      ),
                      margin: EdgeInsets.all(5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${e.name!.firstName}",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${e.kfupmId!}",
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Text(
                                "${e.email ?? "---"}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
        RoundedButton(
          title: "Add Team",
          onTap: () async {
            if (!validTeam()) {
              TopNotification(
                  message: "Make Sure to Select a team with its roster (at least 11 players)", context: context);
              return;
            }
            ProgressDialog pr = ProgressDialog(context);
            await pr.show();
            final futuresCheckPlayersValidity = players.map((e) async {
              final isValid = !(await TournamentServices.isPlayerInTournament(widget.tournament.id, e.kfupmId!));
              return isValid ? "" : e.kfupmId!;
            });

            final invalidIds = (await Future.wait(futuresCheckPlayersValidity));
            invalidIds.removeWhere((element) => element == "");

            if (invalidIds.isNotEmpty) {
              TopNotification(
                message: "These Players already plays in the tournaments with other teams\n${invalidIds.toString()} ",
                context: context,
              );
              pr.hide();
              return;
            }

            await TournamentServices.addTeamToTournament(team!.id, widget.tournament.id);

            final futures = players.map((e) async {
              await TournamentServices.addPlayerToTournamentRoster(team!.id, widget.tournament.id, e.kfupmId!);
            });
            await Future.wait(futures);

            await pr.hide();
            popPage(context);
          },
        )
      ],
    );
  }
}
