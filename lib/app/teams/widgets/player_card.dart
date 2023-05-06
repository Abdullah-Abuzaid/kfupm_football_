// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/providers/team_providers.dart';
import 'package:kfupm_football/app/teams/services/team_services.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/progress_dialog/progress_dialog.dart';

class PlayerCard extends ConsumerStatefulWidget {
  Team team;
  KFUPMMemeber member;
  PlayerCard({
    required this.team,
    required this.member,
  });

  @override
  ConsumerState<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends ConsumerState<PlayerCard> {
  bool inTeam = false;
  @override
  void initState() {
    inTeam = widget.team.players?.where((element) => element.kfupmId == widget.member.kfupmId).length == 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: kCyanDark),
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.member.name!.firstName),
          RoundedButton(
            title: !inTeam ? "Add To Team" : "Remove From Team",
            buttonColor: inTeam ? kRed : kTeal,
            onTap: () async {
              ProgressDialog pr = ProgressDialog(context);
              pr.show();
              !inTeam
                  ? await TeamServices.addPlayerInTeam(widget.member.kfupmId!, widget.team.id)
                  : await TeamServices.removePlayerFromTeam(widget.member.kfupmId!, widget.team.id);

              await pr.hide();
              ref.refresh(fetchTeamsProvider);

              popPage(context);
            },
          ),
          if (inTeam)
            RoundedButton(
              title: "Make Captain",
              onTap: () async {
                ProgressDialog pr = ProgressDialog(context);
                await pr.show();
                await TeamServices.makeCaptain(widget.member.kfupmId!, widget.team.id);
                await pr.hide();
                ref.refresh(fetchTeamsProvider);

                await popPage(context);
              },
            )
        ],
      ),
    );
  }
}
