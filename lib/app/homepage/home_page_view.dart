import 'dart:html';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/animation/constant/color.dart';
import '../../core/animation/opacity_animation.dart';
import '../../core/animation/slideTransition.dart';
import '../../core/constants/assets_contraints.dart';
import '../../core/constants/text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 700,
          child: Stack(
            children: [
              OpacityAnimation(
                delay: Duration(milliseconds: 200),
                curve: Curves.linear,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 800,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          kKfupmlandscape,
                        ),
                      ),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: kBlack.withOpacity(0.1),
                        height: 800,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: OpacityAnimation(
                  child: SlideInAnimation.fromDown(
                    duration: Duration(milliseconds: 700),
                    offset: 100,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(kKfupmLogo),
                          const Text("KFUPM Football Tournaments", textAlign: TextAlign.center, style: h1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
