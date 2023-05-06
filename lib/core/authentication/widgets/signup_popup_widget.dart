import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/alert_dialogs/top_notification.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/authentication/services/authentication_services.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/drop_menu/drop_down_menu.dart';
import 'package:kfupm_football/core/models/kfupm_member.dart';
import 'package:kfupm_football/core/models/name_model.dart';
import 'package:kfupm_football/core/navigations/navigations.dart';
import 'package:kfupm_football/core/textfields/textfields.dart';
import 'package:kfupm_football/core/textfields/validators.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SignUpPopup extends ConsumerStatefulWidget {
  const SignUpPopup({super.key});

  @override
  ConsumerState<SignUpPopup> createState() => _SignUpPopupState();
}

class _SignUpPopupState extends ConsumerState<SignUpPopup> {
  String? email = "";
  String? password = "";
  String? kfupmId;
  String? nationalId;
  String? phoneNumber;
  String? department;
  String? name;
  DateTime? dob;

  MemberType? type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign Up",
          style: h1,
        ),
        SizedBox(
          height: 80,
        ),
        RoundedTextField(
          label: "Email",
          onChange: (email) {
            this.email = email;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          label: "Full Name",
          onChange: (value) {
            this.name = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          label: "KFUPM ID ",
          onChange: (value) {
            this.kfupmId = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          label: "National ID",
          onChange: (value) {
            this.nationalId = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          label: "Phone Number",
          onChange: (value) {
            this.phoneNumber = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          label: "Department",
          onChange: (value) {
            this.department = value;
          },
        ),
        SizedBox(
          height: 20,
        ),
        DropDownMenu(
            items: MemberType.values.map((e) => e.name).toList(),
            hint: "Member Type",
            actualList: MemberType.values,
            onSelect: (type) {
              this.type = type;
            }),
        RoundedButton(
          title: "Date Of Birth",
          onTap: () async {
            dob = await showDatePicker(
                context: context, initialDate: DateTime(2000), firstDate: DateTime(1940), lastDate: DateTime.now());
          },
        ),
        SizedBox(
          height: 20,
        ),
        RoundedTextField(
          obsecureText: true,
          label: "Password",
          onChange: (value) {
            this.password = value;
          },
        ),
        SizedBox(
          height: 50,
        ),
        RoundedButton(
          title: "SignUp",
          onTap: () async {
            if (validUser(email, password, nationalId, phoneNumber, kfupmId, department, dob, type, name)) {
              Session? session = null;
              try {
                session = (await ref.watch(authUser).signUp(email!, password!)).session;
              } catch (e) {
                await ref.watch(authUser).signIn(email!, password!);
                session = ref.watch(authUser).session;
                print(e);
              }

              if (session != null) {
                final member = KFUPMMemeber(
                  name: Name(firstName: name!),
                  kfupmId: kfupmId,
                  nationalId: nationalId,
                  dob: dob,
                  phoneNumbers: [phoneNumber!],
                  email: email,
                  type: type,
                  department: department,
                  uid: session!.user.id,
                );
                try {
                  await AuthServices.postUser(member);
                  await ref.watch(authUser).signIn(email!, password!);
                  popPage(context);
                } catch (e) {
                  TopNotification(message: e.toString(), context: context);
                }

                ref.watch(authUser).setMember(member);
              }
            } else
              TopNotification(message: "Please Make Sure All Fields Are Entered Correctly", context: context);
          },
        )
      ],
    );
  }
}
