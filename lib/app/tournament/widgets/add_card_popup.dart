import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';

import '../../../core/animation/bounce_button.dart';
import '../../../core/constants/text_styles.dart';
import '../../../core/drop_menu/drop_down_menu.dart';
import '../../../core/navigations/navigations.dart';
import '../../../core/textfields/textfields.dart';
import '../services/tournament_services.dart';
import 'add_match_popup.dart';

class AddTournamentCardPopup extends ConsumerStatefulWidget {
  TournamentMatch match;

  AddTournamentCardPopup({super.key, required this.match});

  @override
  ConsumerState<AddTournamentCardPopup> createState() => _AddTournamentCardPopupState();
}

class _AddTournamentCardPopupState extends ConsumerState<AddTournamentCardPopup> {
  CardType? type;
  MatchTeam? forTeam;
  MatchPlayer? forPlayer;
  DateTime? dateTime;
  KFUPMMemeber? referee;

  bool isValidCard() {
    return type != null && forPlayer != null && forTeam != null && dateTime != null && referee != null;
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
          actualList: CardType.values,
          items: CardType.values.map((e) => e.name).toList(),
          hint: "Card Type",
          onSelect: (value) {
            type = value;
            setState(() {});
          },
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
          DropDownMenu(
            actualList: forTeam!.players,
            items: forTeam!.players!.map((e) => e.member!.name!.firstName).toList(),
            hint: "For Player",
            onSelect: (value) {
              forPlayer = value;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          ref.watch(fetchReferee).when(
                data: (referee) {
                  return DropDownMenu(
                    actualList: referee,
                    items: referee!.map((e) => e.name!.firstName).toList(),
                    hint: "Given By Referee",
                    onSelect: (value) {
                      this.referee = value;
                      setState(() {});
                    },
                  );
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(
                    error.toString(),
                  ),
                ),
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
                  if (isValidCard()) {
                    await TournamentServices.insertCard(
                      TournamentCard(
                        type: type,
                        givenBy: referee!.kfupmId,
                        tournamentId: widget.match.tournamentId,
                        atMatchId: widget.match.id,
                        takenAt: dateTime,
                        forId: forPlayer!.member!.kfupmId,
                        teamID: forTeam!.team!.id,
                      ),
                    );

                    await popPage(context);
                  }
                },
              ),
              RoundedButton(
                titleColor: kRed,
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
