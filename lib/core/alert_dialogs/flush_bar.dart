import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../animation/constant/color.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';

class FlushBar extends StatefulWidget {
  OverlayEntry? overlayEntry;
  String? message;
  int? animationDuration;
  int? autoDismissDelay;
  Widget? customWidget;
  Curve? curve;
  bool? dismissible;
  bool? autoDismissible;
  BuildContext context;

  FlushBar(
      {required this.overlayEntry,
      required this.message,
      required this.context,
      this.curve,
      this.autoDismissible,
      this.dismissible,
      this.animationDuration,
      this.autoDismissDelay,
      Key? key})
      : super(key: key) {
    this.curve ??= Curves.easeOutQuart;
    this.autoDismissible ??= true;
    this.dismissible ??= true;
    this.animationDuration ??= 1200;
    this.autoDismissDelay ??= 1200;
  }

  FlushBar.custom(
      {required this.overlayEntry,
      required this.customWidget,
      required this.context,
      this.curve,
      this.autoDismissible,
      this.dismissible,
      this.animationDuration,
      this.autoDismissDelay,
      Key? key})
      : super(key: key) {
    this.curve ??= Curves.easeOutQuart;
    this.autoDismissible ??= true;
    this.dismissible ??= true;
    this.animationDuration ??= 1200;
    this.autoDismissDelay ??= 1200;
  }

  @override
  State<FlushBar> createState() => _FlushBarState();
}

class _FlushBarState extends State<FlushBar> with TickerProviderStateMixin {
  CurvedAnimation? curvedAnimation;
  Animation? controllers;
  AnimationController? controller;
  bool isReversing = false;
  double initOffset = -200;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration!),
    );
    curvedAnimation = CurvedAnimation(
      parent: controller!,
      curve: widget.curve!,
    );
    controller!.forward();
    //auto dismiss after given time has passed
    Future.delayed(Duration(milliseconds: widget.animationDuration! + widget.autoDismissDelay!)).then((value) {
      if (!isReversing && widget.autoDismissible!) reverse();
    });
  }

  void reverse() async {
    if (!isReversing) {
      isReversing = true;
      await controller!.reverse();
      widget.overlayEntry!.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: curvedAnimation!,
        builder: (context, animation) {
          return GestureDetector(
            onVerticalDragEnd: (details) {
              //Check if swipe up

              controller!.reverseDuration = Duration(milliseconds: 500);
              isReversing = false;
              reverse();
            },
            onVerticalDragUpdate: (details) {
              isReversing = true;
              if (initOffset <= -190)
                initOffset = (initOffset + details.delta.dy) > -190 ? -190 : (initOffset + details.delta.dy);
              setState(() {});
            },
            child: Opacity(
              opacity: ((curvedAnimation!.value) + 0.1) > 1 ? 1 : ((curvedAnimation!.value) + 0.1),
              child: Transform.translate(
                offset: Offset(0, initOffset),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Transform.translate(
                    offset: Offset(
                        0,
                        (MediaQuery.of(context).size.height / 4.5) * curvedAnimation!.value +
                            100 * curvedAnimation!.value),
                    child: widget.customWidget ??
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 80,
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: kCyan),
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: Center(
                              child: Text(
                                widget.message ?? "",
                                style: h1.copyWith(fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
