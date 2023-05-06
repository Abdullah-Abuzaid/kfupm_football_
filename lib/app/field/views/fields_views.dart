import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/app/field/providers/field_providers.dart';
import 'package:kfupm_football/app/field/widget/create_field_popup.dart';
import 'package:kfupm_football/app/field/widget/field_card.dart';

import '../../../core/alert_dialogs/alert_dialog_box.dart';
import '../../../core/animation/bounce_button.dart';
import '../../../core/constants/text_styles.dart';
import '../../teams/widgets/create_team_popup.dart';

class FieldsView extends ConsumerStatefulWidget {
  const FieldsView({super.key});

  @override
  ConsumerState<FieldsView> createState() => _FieldsViewState();
}

class _FieldsViewState extends ConsumerState<FieldsView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Fields",
              style: h1,
            ),
            RoundedButton(
              title: "Create New Field",
              onTap: () async {
                AlertDialogBox.showCustomDialog(context: context, widget: CreateFieldPopup());
              },
            ),
          ],
        ),
        ref.watch(fieldsProvider).when(
            data: (data) {
              return Wrap(
                spacing: 20,
                runSpacing: 20,
                children: data.map((e) => FieldCard(field: e)).toList(),
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
