// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ScaleAnimation extends StatefulWidget {
  Widget child;
  Duration duration;
  double startScale;
  double endScale;

  Curve curve;

  ScaleAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 900),
    this.startScale = 0,
    this.endScale = 1,
    this.curve = Curves.easeOutQuad,
  }) : super(key: key);

  @override
  State<ScaleAnimation> createState() => _ScaleAnimationState();
}

class _ScaleAnimationState extends State<ScaleAnimation> {
  late double scale;
  @override
  void initState() {
    scale = widget.startScale;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(Duration(milliseconds: 100));
      setState(() {
        scale = widget.endScale;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      curve: widget.curve,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
