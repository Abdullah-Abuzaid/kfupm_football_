// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:html';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/field/providers/field_providers.dart';
import 'package:kfupm_football/app/tournament/widgets/choose_team_match_players_popup.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/models/field_model.dart';
import 'package:kfupm_football/core/models/match_model.dart';
import 'package:kfupm_football/core/models/match_player_model.dart';
import 'package:kfupm_football/core/models/match_team_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import 'package:kfupm_football/app/teams/services/team_services.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/location_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/textfields/auto_complete_tf.dart';
import 'package:kfupm_football/core/textfields/textfields.dart';

import '../../../core/animation/bounce_animation.dart';
import '../../../core/animation/constant/color.dart';
import '../../../core/animation/on_click_bounce.dart';
import '../../../core/drop_menu/drop_down_menu.dart';
import '../../teams/providers/team_providers.dart';

class CreateTournamentMatchPopup extends ConsumerStatefulWidget {
  Tournament tournament;
  CreateTournamentMatchPopup({
    required this.tournament,
  });

  @override
  ConsumerState<CreateTournamentMatchPopup> createState() => _CreateTeamPopupState();
}

class _CreateTeamPopupState extends ConsumerState<CreateTournamentMatchPopup> {
  MatchType? type;
  int? points;
  KFUPMMemeber? referee;
  DateTime? startDate;
  Field? field;
  MatchTeam? team1;
  MatchTeam? team2;

  String matchID = "";

  // bool validMatch() {
  //   return startDate != null &&
  //       type != null &&
  //       matchTeam1 != null &&
  //       ((matchTeam1?.players?.length ?? 0) >= 11 && matchTeams != null && ((matchTeam2?.players?.length ?? 0) >= 11));
  // }

  bool isSelectedPlayer(MatchTeam matchTeam, String kfupmId) {
    return matchTeam.players!.map((e) => e.member!.kfupmId).contains(kfupmId);
  }

  bool isValidMatch() {
    return team1 != null &&
        team2 != null &&
        (type != null || (type == MatchType.points && points == null)) &&
        startDate != null;
  }

  @override
  void initState() {
    matchID = Uuid().v1();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Create Tournament Match",
          style: h1,
        ),
        SizedBox(
          height: 50,
        ),
        DropDownMenu(
          items: MatchType.values.map((e) => e.name).toList(),
          actualList: MatchType.values,
          hint: "Match Type",
          onSelect: (value) {
            type = value;
          },
        ),
        SizedBox(
          height: 50,
        ),
        ref.watch(fieldsProvider).when(data: (data) {
          return DropDownMenu(
            hint: "Choose a Match Field",
            actualList: data,
            items: data.map((e) => e.name).toList(),
            onSelect: (value) {
              field = value;
              setState(() {});
            },
          );
        }, error: (e, s) {
          return Center(
            child: Text(e.toString()),
          );
        }, loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
        SizedBox(
          height: 50,
        ),
        ref.watch(fetchReferee).when(data: (data) {
          return DropDownMenu(
            hint: "Choose a Match Referee",
            actualList: data,
            items: data.map((e) => e.name!.firstName).toList(),
            onSelect: (value) {
              referee = value;
              setState(() {});
            },
          );
        }, error: (e, s) {
          return Center(
            child: Text(e.toString()),
          );
        }, loading: () {
          return Center(
            child: CircularProgressIndicator(),
          );
        }),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Points ",
          onChange: (value) {
            this.points = int.tryParse(value ?? "");
          },
        ),
        RoundedButton(
          title: "Choose Starting Date",
          onTap: () async {
            startDate = await showDateTimePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2060),
            );
 
            setState(() {});
          },
        ),
        if (startDate != null) ...[
          RoundedButton(
            title: "Choose Team 1",
            onTap: () async {
              final team1 = await AlertDialogBox.showCustomDialog(
                  context: context,
                  widget: ChooseTeamMatchPlayers(
                    tournament: widget.tournament,
                    matchId: matchID,
                    starttime: startDate!,
                    otherTeam: team2,
                  ));
              if (team1 != null) this.team1 = team1;
            },
          ),
          RoundedButton(
            title: "Choose Team 2",
            onTap: () async {
              final team2 = await AlertDialogBox.showCustomDialog(
                  context: context,
                  widget: ChooseTeamMatchPlayers(
                    tournament: widget.tournament,
                    matchId: matchID,
                    starttime: startDate!,
                    otherTeam: team1,
                  ));
              if (team2 != null) this.team2 = team2;
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundedButton(
                title: "Submit",
                onTap: () async {
                  if (isValidMatch()) {
                    await TournamentServices.addTournamentMatch(
                        [team1!, team2!],
                        TournamentMatch(
                          field: field,
                          startDate: startDate,
                          referee: referee,
                          type: type,
                          points: points,
                          id: matchID,
                          tournamentId: widget.tournament.id,
                        ));
                    popPage(context);
                  } else {
                    TopNotification(message: "Please Fill All Required Fields", context: context);
                  }
                },
              ),
              RoundedButton(
                title: "Cancel",
                onTap: () {
                  popPage(context);
                },
              ),
            ],
          )
        ]
      ],
    );
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  initialDate ??= DateTime.now();
  firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
  lastDate ??= firstDate.add(const Duration(days: 365 * 200));

  final DateTime? selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );

  if (selectedDate == null) return null;

  if (!context.mounted) return selectedDate;

  final TimeOfDay? selectedTime = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(selectedDate),
  );

  return selectedTime == null
      ? selectedDate
      : DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
}
