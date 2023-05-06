// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'constant/color.dart';

class OnHoverScale extends StatefulWidget {
  Widget child;
  Duration duration;
  Curve curve;
  double maxScale;
  OnHoverScale({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeOutQuad,
    this.maxScale = 1.2,
  }) : super(key: key);

  @override
  State<OnHoverScale> createState() => _OnHoverScaleState();
}

class _OnHoverScaleState extends State<OnHoverScale> {
  double scale = 1;

  void animate() {
    setState(() {
      scale = widget.maxScale;
    });
    Future.delayed(const Duration(milliseconds: 400)).then((value) {
      setState(() {
        scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: kTransparent,
      borderRadius: BorderRadius.circular(20),
      mouseCursor: MouseCursor.uncontrolled,
      onHover: (value) {
        if (value) {
          setState(() {
            scale = widget.maxScale;
          });
        } else {
          setState(() {
            scale = 1;
          });
        }
      },
      onTap: () {},
      child: AnimatedScale(
        scale: scale,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
