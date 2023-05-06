// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'constant/color.dart';

class OnClickScale extends StatefulWidget {
  Widget child;
  Duration duration;
  Curve curve;
  double maxScale;
  Function()? onTap;
  OnClickScale({
    Key? key,
    required this.child,
    this.onTap,
    this.duration = const Duration(milliseconds: 180),
    this.curve = Curves.easeInQuad,
    this.maxScale = 1.1,
  }) : super(key: key);

  @override
  State<OnClickScale> createState() => _OnClickScaleState();
}

class _OnClickScaleState extends State<OnClickScale> {
  double scale = 1;

  Future<void> animate() async {
    setState(() {
      scale = widget.maxScale;
    });
    await Future.delayed(widget.duration).then((value) {
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
      onTap: () async {
        await animate();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: scale,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}
