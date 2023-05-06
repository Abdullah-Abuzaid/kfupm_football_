// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kfupm_football/core/side_menu/side_menu_button.dart';

import '../../menu/provider/menu_provider.dart';
import '../animation/bounce_animation.dart';
import '../animation/constant/color.dart';
import '../animation/on_click_bounce.dart';
import '../constants/assets_contraints.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class SideMenu extends StatefulWidget {
  Color activeButton;
  Color inActiveButton;

  List<SideMenuButton> buttons;
  Widget? trailings;

  SideMenu(
      {super.key,
      required this.buttons,
      this.activeButton = kPrimaryColor,
      this.inActiveButton = kCyanDark,
      this.trailings});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: MediaQuery.of(context).size.width,
      constraints: BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
      ),
      child: Wrap(
        runSpacing: 20,
        spacing: 20,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: <Widget>[
              Consumer(builder: (context, ref, child) {
                return OnHoverScale(
                  maxScale: 1.05,
                  child: OnClickScale(
                    onTap: () {
                      ref.read(menuProvider.notifier).state = 0;
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          kSportClubLogo,
                          height: 80,
                        ),
                        Text("KFUPM Sport Club", style: t2),
                      ],
                    ),
                  ),
                );
              })
            ] +
            [
              FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...List<Widget>.generate(
                      widget.buttons.length,
                      (index) => _SideMenuButtonWidget(
                        data: widget.buttons[index],
                        activeColor: widget.activeButton,
                        inActiveColor: widget.inActiveButton,
                        index: index,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.trailings != null)
                FittedBox(
                  child: widget.trailings!,
                )
              else
                SizedBox()
            ],
      ),
    );
  }
}

class _SideMenuButtonWidget extends ConsumerStatefulWidget {
  SideMenuButton data;
  Color activeColor;
  Color inActiveColor;

  int index;
  _SideMenuButtonWidget({
    Key? key,
    required this.data,
    required this.activeColor,
    required this.inActiveColor,
    required this.index,
  }) : super(key: key);

  @override
  ConsumerState<_SideMenuButtonWidget> createState() => _SideMenuButtonWidgetState();
}

class _SideMenuButtonWidgetState extends ConsumerState<_SideMenuButtonWidget> {
  late bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    isSelected = ref.watch(menuProvider) == widget.index;
    return OnHoverScale(
      maxScale: 1.05,
      child: OnClickScale(
        maxScale: 1.1,
        onTap: () {
          widget.data.onTap();
          if (widget.data.activeColor) ref.read(menuProvider.notifier).state = widget.index;
        },
        child: AnimatedContainer(
          margin: EdgeInsets.symmetric(horizontal: 10),
          height: 80,
          duration: const Duration(milliseconds: 400),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(widget.data.title, style: t1.copyWith(color: isSelected ? kAmber : kWhite)),
            ],
          ),
        ),
      ),
    );
  }
}
