import 'dart:html';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/teams/services/team_services.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/location_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/textfields/auto_complete_tf.dart';
import 'package:kfupm_football/core/textfields/textfields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateTeamPopup extends ConsumerStatefulWidget {
  const CreateTeamPopup({super.key});

  @override
  ConsumerState<CreateTeamPopup> createState() => _CreateTeamPopupState();
}

class _CreateTeamPopupState extends ConsumerState<CreateTeamPopup> {
  String? name;
  String? phoneNumber;
  String? building;
  String? room;
  String? email;
  String? website;
  KFUPMMemeber? coach;
  KFUPMMemeber? manager;
  late TextEditingController managerTextField;
  late TextEditingController coachTextField;
  PlatformFile? imageFile;
  @override
  void initState() {
    managerTextField = TextEditingController();
    coachTextField = TextEditingController();
    super.initState();
  }

  bool validTeam() {
    return name != null &&
        phoneNumber != null &&
        imageFile != null &&
        imageFile!.bytes != null &&
        coach != null &&
        manager != null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Create Team",
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RoundedTextField(
              width: 200,
              label: "Building",
              onChange: (value) {
                this.building = value;
              },
            ),
            RoundedTextField(
              width: 200,
              label: "Room",
              onChange: (value) {
                this.room = value;
              },
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          label: "Website link",
          onChange: (value) {
            this.website = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          label: "Email",
          onChange: (value) {
            this.email = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          label: "Phone Number",
          onChange: (value) {
            this.phoneNumber = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        AheadRoundedTextField<KFUPMMemeber>(
          suggestionsCallback: (text) async {
            return await AuthServices.fetchCoaches(text);
          },
          onSuggestionSelected: (selected) {
            coach = selected;
            coachTextField.text = selected!.name!.firstName!;
            setState(() {});
          },
          itemBuilder: (context, member) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                member!.name!.firstName,
                style: t1,
              ),
            );
          },
          controller: coachTextField,
          label: "Choose a Coach",
        ),
        SizedBox(
          height: 40,
        ),
        AheadRoundedTextField<KFUPMMemeber>(
          controller: managerTextField,
          suggestionsCallback: (text) async {
            return await AuthServices.fetchManagers(text);
          },
          onSuggestionSelected: (selected) {
            manager = selected;
            managerTextField.text = selected!.name!.firstName!;

            setState(() {});
          },
          itemBuilder: (context, member) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                member!.name!.firstName,
                style: t1,
              ),
            );
          },
          label: "Choose a Manager",
        ),
        SizedBox(
          height: 40,
        ),
        RoundedButton(
          width: 400,
          title: "Team Image (${imageFile?.name ?? "not yet Chosen"})",
          onTap: () async {
            final result = (await FilePickerWeb.platform.pickFiles(allowMultiple: false));
            if (result != null) {
              imageFile = result.files.first;
              setState(() {});
            }
          },
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              title: "Create Team",
              onTap: () async {
                if (validTeam()) {
                  await TeamServices.postTeam(
                    Team(
                      coach: coach!,
                      manager: manager!,
                      name: name!,
                      id: Uuid().v1(),
                      location: Location(building: building, room: room),
                      website: website ?? "",
                      email: email ?? "",
                      contactNumbers: [phoneNumber!],
                    ),
                    imageFile!,
                  );
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
