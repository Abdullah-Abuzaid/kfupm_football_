import 'dart:html';
import 'dart:math';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/field/providers/field_providers.dart';
import 'package:kfupm_football/app/field/services/field_services.dart';
import 'package:kfupm_football/app/teams/services/team_services.dart';
import 'package:kfupm_football/app/tournament/providers/tournament_provider.dart';
import 'package:kfupm_football/app/tournament/services/tournament_services.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/models/field_model.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/location_model.dart';
import 'package:kfupm_football/core/models/team_model.dart';
import 'package:kfupm_football/core/models/tournament_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/textfields/auto_complete_tf.dart';
import 'package:kfupm_football/core/textfields/textfields.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateFieldPopup extends ConsumerStatefulWidget {
  const CreateFieldPopup({super.key});

  @override
  ConsumerState<CreateFieldPopup> createState() => _CreateTeamPopupState();
}

class _CreateTeamPopupState extends ConsumerState<CreateFieldPopup> {
  String? name;
  String? room;
  String? building;
  int? length;
  int? width;
  int? crowdSize;

  bool validField() {
    return name != null && room != null && building != null && length != null && width != null && crowdSize != null;
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
          width: 300,
          label: "Building",
          onChange: (value) {
            this.building = value;
          },
        ),
        RoundedTextField(
          minLines: 2,
          maxLines: 4,
          width: 300,
          label: "Room",
          onChange: (value) {
            this.room = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Crowd Size",
          onChange: (value) {
            this.crowdSize = int.tryParse(value ?? "");
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Length in cm",
          onChange: (value) {
            this.length = int.tryParse(value ?? "");
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          width: 400,
          textInputType: TextInputType.number,
          formatter: [FilteringTextInputFormatter.digitsOnly],
          label: "Width in cm",
          onChange: (value) {
            this.width = int.tryParse(value ?? "");
          },
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RoundedButton(
              title: "Create Tournament",
              onTap: () async {
                if (validField()) {
                  await FieldServices.addField(
                    Field(
                        name: name,
                        id: Uuid().v1(),
                        building: building,
                        room: room,
                        crowdSize: crowdSize,
                        length: length,
                        width: width),
                  );
                  await popPage(context);

                  ref.invalidate(fieldsProvider);
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
