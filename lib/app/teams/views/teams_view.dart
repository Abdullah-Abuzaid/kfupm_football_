import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/providers/team_providers.dart';
import 'package:kfupm_football/app/teams/widgets/create_team_popup.dart';
import 'package:kfupm_football/app/teams/widgets/team_card.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/team_model.dart';

class TeamsView extends ConsumerStatefulWidget {
  const TeamsView({super.key});

  @override
  ConsumerState<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends ConsumerState<TeamsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Teams",
              style: h1,
            ),
            RoundedButton(
              title: "Create New Team",
              onTap: () async {
                AlertDialogBox.showCustomDialog(context: context, widget: CreateTeamPopup());
              },
            ),
          ],
        ),
        ref.watch(fetchTeamsProvider).when(
            data: (data) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data.map((e) => TeamCard(team: e)).toList(),
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
