import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kfupm_football/app/field/views/fields_views.dart';
import 'package:kfupm_football/app/teams/views/teams_view.dart';
import 'package:kfupm_football/app/tournament/views/tournaments_view.dart';
import 'package:kfupm_football/core/alert_dialogs/alert_dialog_box.dart';
import 'package:kfupm_football/core/animation/bounce_animation.dart';
import 'package:kfupm_football/core/animation/constant/color.dart';
import 'package:kfupm_football/core/animation/on_click_bounce.dart';
import 'package:kfupm_football/core/authentication/providers/authentication_providers.dart';
import 'package:kfupm_football/core/authentication/widgets/sign_in_popup_widget.dart';
import 'package:kfupm_football/core/authentication/widgets/signup_popup_widget.dart';
import 'package:kfupm_football/core/constants/text_styles.dart';
import 'package:kfupm_football/menu/provider/menu_provider.dart';

import '../app/homepage/home_page_view.dart';
import '../core/constants/assets_contraints.dart';
import '../core/side_menu/side_menu.dart';
import '../core/side_menu/side_menu_button.dart';

class MenuWrapper extends ConsumerStatefulWidget {
  const MenuWrapper({super.key});

  @override
  ConsumerState<MenuWrapper> createState() => _MenuWrapperState();
}

class _MenuWrapperState extends ConsumerState<MenuWrapper> {
  final pages = [
    HomePage(),
    TeamsView(),
    TournamentsView(),
    FieldsView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SideMenu(
              buttons: [
                SideMenuButton(
                  icon: SizedBox(width: 80, child: SvgPicture.asset(k3DLogo)),
                  onTap: () {
                    ref.read(menuProvider.notifier).state = 0;
                  },
                  title: "Home",
                ),
                SideMenuButton(
                  icon: SizedBox(width: 80, child: SvgPicture.asset(k3DLogo)),
                  onTap: () {
                    ref.read(menuProvider.notifier).state = 1;
                  },
                  title: "Teams",
                ),
                SideMenuButton(
                  icon: SizedBox(width: 80, child: SvgPicture.asset(k3DLogo)),
                  onTap: () {
                    ref.read(menuProvider.notifier).state = 2;
                  },
                  title: "Tournaments",
                ),
                SideMenuButton(
                  icon: SizedBox(width: 80, child: SvgPicture.asset(k3DLogo)),
                  onTap: () {
                    ref.read(menuProvider.notifier).state = 3;
                  },
                  title: "Fields",
                ),
              ],
              trailings: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (ref.watch(authUser).session == null) ...[
                    OnHoverScale(
                      child: OnClickScale(
                        onTap: () {
                          AlertDialogBox.showCustomDialog(
                              context: context, widget: SignInPopup(), width: 300, height: 300);
                        },
                        child: Text(
                          "Login",
                          style: t1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    OnHoverScale(
                      child: OnClickScale(
                        onTap: () {
                          AlertDialogBox.showCustomDialog(context: context, widget: SignUpPopup(), width: 600);
                          print(ref.watch(authUser).session);
                        },
                        child: Text(
                          "Sign In",
                          style: t1.copyWith(color: kAmber),
                        ),
                      ),
                    ),
                  ],
                  if (ref.watch(authUser).session != null) ...[
                    OnHoverScale(
                      child: OnClickScale(
                        onTap: () {
                          ref.watch(authUser).signout();
                        },
                        child: Text(
                          "Sign Out",
                          style: t1.copyWith(color: kRed),
                        ),
                      ),
                    ),
                  ]
                ],
              )),
          Expanded(
            child: SingleChildScrollView(
              controller: ScrollController(),
              physics: AlwaysScrollableScrollPhysics(),
              child: Consumer(
                builder: (context, ref, child) {
                  return pages[ref.watch(menuProvider)];
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
