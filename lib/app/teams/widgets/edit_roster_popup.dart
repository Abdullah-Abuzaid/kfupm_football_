// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kfupm_football/app/teams/widgets/player_card.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/team_model.dart';

class EditRosterPopup extends ConsumerStatefulWidget {
  Team team;
  EditRosterPopup({
    required this.team,
  });

  @override
  ConsumerState<EditRosterPopup> createState() => _EditRosterPopupState();
}

class _EditRosterPopupState extends ConsumerState<EditRosterPopup> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Edit Team Roster",
          style: h1,
        ),
        SizedBox(
          height: 1000,
          width: 1000,
          child: ListView(
            shrinkWrap: true,
            children: ref.watch(fetchUsers).when(data: (users) {
              final players = users.where((user) => user.type == MemberType.player);
              if (players.isEmpty)
                return [
                  Center(
                    child: Text("There Are no Players"),
                  )
                ];
              return players.map((e) => PlayerCard(team: widget.team, member: e)).toList();
            }, error: (error, stackTrace) {
              return [Text(error.toString())];
            }, loading: () {
              return [
                Center(
                  child: CircularProgressIndicator(),
                )
              ];
            }),
          ),
        )
      ],
    );
  }
}
