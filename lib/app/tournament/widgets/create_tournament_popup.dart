import 'dart:html';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateTournamentPopup extends ConsumerStatefulWidget {
  const CreateTournamentPopup({super.key});

  @override
  ConsumerState<CreateTournamentPopup> createState() => _CreateTeamPopupState();
}

class _CreateTeamPopupState extends ConsumerState<CreateTournamentPopup> {
  String? name;
  String? description;
  int? prizePool;
  DateTime? endDate;
  DateTime? startDate;

  bool validTournament() {
    return name != null && startDate != null && endDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Create Tournament",
          style: h1,
        ),
        SizedBox(
          height: 50,
        ),
        RoundedTextField(
          width: 400,
          label: "Name",
          onChange: (value) {
            this.name = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          minLines: 2,
          maxLines: 4,
          width: 600,
          label: "Description",
          onChange: (value) {
            this.description = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Prize Pool (Leave empty if there is none)",
          onChange: (value) {
            this.prizePool = int.tryParse(value ?? "");
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedButton(
          height: 90,
          title:
              "Choose Start and End Date (${startDate?.toString() ?? "none" + "-" + (endDate?.toString() ?? "none")})",
          onTap: () async {
            final dateRange =
                await showDateRangePicker(context: context, firstDate: DateTime.now(), lastDate: DateTime(2080));
            if (dateRange != null) {
              startDate = dateRange.start;
              endDate = dateRange.end;
              setState(() {});
            }
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              title: "Create Tournament",
              onTap: () async {
                if (validTournament()) {
                  await TournamentServices.createNewTournament(
                    Tournament(
                        prizePool: prizePool ?? 0,
                        id: Uuid().v1(),
                        name: name!,
                        startDate: startDate!,
                        description: description,
                        endDate: endDate!,
                        madeBy: ref.watch(authUser).member),
                  );
                  await popPage(context);

                  ref.invalidate(fetchTournaments);
                } else
                  TopNotification(message: "Please Make Sure to Fill All Required Fields", context: context);
              },
            ),
            SizedBox(
              width: 30,
            ),
            RoundedButton(
              title: "Cancel",
              buttonColor: Colors.red,
              onTap: () => popPage(context),
            )
          ],
        )
      ],
    );
  }
}
