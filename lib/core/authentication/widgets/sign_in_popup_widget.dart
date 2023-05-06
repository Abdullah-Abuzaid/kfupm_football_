import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/core/textfields/textfields.dart';

class SignInPopup extends ConsumerStatefulWidget {
  const SignInPopup({super.key});

  @override
  ConsumerState<SignInPopup> createState() => _SignUpPopupState();
}

class _SignUpPopupState extends ConsumerState<SignInPopup> {
  String? email = "";
  String? password = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Sign In",
          style: t1,
        ),
        SizedBox(
          height: 40,
        ),
        RoundedTextField(
          label: "Email",
          onChange: (email) {
            this.email = email;
          },
        ),
        SizedBox(
          height: 30,
        ),
        RoundedTextField(
          label: "Password",
          onChange: (password) {
            this.password = password;
          },
        ),
        SizedBox(
          height: 50,
        ),
        RoundedButton(
          title: "Sign In",
          onTap: () {
            if (password != null && email != null && password!.length > 8)
              ref.watch(authUser).signIn(email!, password!);
          },
        )
      ],
    );
  }
}
