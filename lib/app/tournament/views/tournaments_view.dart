import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/providers/team_providers.dart';
import 'package:kfupm_football/app/teams/widgets/create_team_popup.dart';
import 'package:kfupm_football/app/teams/widgets/team_card.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/app/tournament/widgets/create_tournament_popup.dart';
import 'package:kfupm_football/app/tournament/widgets/tournament_card.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/card_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';

class TournamentsView extends ConsumerStatefulWidget {
  const TournamentsView({super.key});

  @override
  ConsumerState<TournamentsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends ConsumerState<TournamentsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Tournaments",
              style: h1,
            ),
            RoundedButton(
              title: "Create New Tournament",
              onTap: () async {
                AlertDialogBox.showCustomDialog(context: context, widget: CreateTournamentPopup());
              },
            ),
          ],
        ),
        ref.watch(fetchTournaments).when(
            data: (data) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data.map((e) => TournamentCardWidget(tournament: e)).toList(),
              );
            },
            error: (error, s) {
              return Center(child: Text(error.toString()));
            },
            loading: () => Center(child: CircularProgressIndicator()))
      ],
    );
  }
}
