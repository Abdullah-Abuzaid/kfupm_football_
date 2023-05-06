import 'package:flutter/material.dart';

class OpacityAnimation extends StatefulWidget {
  Widget child;
  Duration duration;
  Curve curve;
  Duration delay;

  OpacityAnimation(
      {super.key,
      required this.child,
      this.delay = const Duration(milliseconds: 0),
      this.curve = Curves.easeOutQuad,
      this.duration = const Duration(milliseconds: 900)});

  @override
  State<OpacityAnimation> createState() => _OpacityAnimationState();
}

class _OpacityAnimationState extends State<OpacityAnimation> {
  double opacity = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Future.delayed(widget.delay);
      setState(() {
        opacity = 1;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: widget.curve,
      opacity: opacity,
      duration: widget.duration,
      child: widget.child,
    );
  }
}
