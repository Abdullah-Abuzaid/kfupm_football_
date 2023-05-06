// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kfupm_football/app/teams/widgets/avatar_widget.dart';
import 'package:kfupm_football/app/teams/widgets/edit_roster_popup.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/team_model.dart';

class TeamView extends ConsumerStatefulWidget {
  Team team;

  TeamView({
    required this.team,
  });

  @override
  ConsumerState<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends ConsumerState<TeamView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AvatarImage(
              imgUrl: widget.team.imageUrl!,
              width: 200,
              height: 200,
            ),
            Text(
              widget.team.name,
              style: h1,
            ),
          ],
        ),
        Table(
          defaultColumnWidth: FixedColumnWidth(220.0),
          border: TableBorder.all(
              color: Colors.teal, style: BorderStyle.solid, width: 3, borderRadius: BorderRadius.circular(10)),
          children: [
            TableRow(children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Managed By', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Coached By', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Building', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Room', style: t1),
                )
              ]),
            ]),
            TableRow(children: [
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(widget.team.manager?.name?.firstName ?? "", style: t2),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.team.coach?.name?.firstName ?? "", style: t2),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(widget.team.location.building ?? "", style: t2),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    widget.team.location.room ?? "",
                    style: t2,
                  ),
                )
              ]),
            ]),
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
                  child: Text('Date of Birth', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Email', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('Phone', style: t1),
                )
              ]),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text('KFUPM ID', style: t1),
                )
              ]),
            ]),
            ...widget.team.players!
                .map(
                  (e) => TableRow(children: [
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(e.name!.firstName, style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.dob!.toString(), style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.email!, style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.phoneNumbers?.toString() ?? "-", style: t2),
                      )
                    ]),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(e.kfupmId!, style: t2),
                      )
                    ]),
                  ]),
                )
                .toList()
          ],
        ),
        RoundedButton(
          title: "Edit Team Roster",
          onTap: () async {
            await AlertDialogBox.showCustomDialog(context: context, widget: EditRosterPopup(team: widget.team));
          },
        )
      ],
    );
  }
}
