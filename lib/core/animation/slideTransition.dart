import 'package:flutter/material.dart';

class SlideInAnimation extends StatefulWidget {
  Widget child;
  double yOffset;
  double xOffset;
  Duration duration;
  Curve curve;

  SlideInAnimation(
      {super.key,
      required this.child,
      this.yOffset = -40,
      this.xOffset = 0,
      this.duration = const Duration(milliseconds: 900),
      this.curve = Curves.linear});
  factory SlideInAnimation.fromLeft({
    required Widget child,
    required double offset,
    Duration duration = const Duration(milliseconds: 900),
    Curve curve = Curves.linear,
  }) {
    return SlideInAnimation(
      xOffset: -offset,
      yOffset: 0,
      child: child,
      curve: curve,
      duration: duration,
    );
  }
  factory SlideInAnimation.fromRight({
    required Widget child,
    required double offset,
    Duration duration = const Duration(milliseconds: 900),
    Curve curve = Curves.linear,
  }) {
    print(duration.inMilliseconds);
    print(curve.toString());
    return SlideInAnimation(
      xOffset: offset,
      yOffset: 0,
      child: child,
      curve: curve,
      duration: duration,
    );
  }
  factory SlideInAnimation.fromUp({
    required Widget child,
    required double offset,
    Duration duration = const Duration(milliseconds: 900),
    Curve curve = Curves.linear,
  }) {
    return SlideInAnimation(
      xOffset: 0,
      yOffset: -offset,
      child: child,
      curve: curve,
      duration: duration,
    );
  }
  factory SlideInAnimation.fromDown({
    required Widget child,
    required double offset,
    Duration duration = const Duration(milliseconds: 900),
    Curve curve = Curves.linear,
  }) {
    return SlideInAnimation(
      xOffset: 0,
      yOffset: offset,
      child: child,
      curve: curve,
      duration: duration,
    );
  }
  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: widget.duration);
    animation = CurvedAnimation(parent: controller, curve: widget.curve);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      controller.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(widget.xOffset * (1 - controller.value), widget.yOffset * (1 - controller.value)),
          child: widget.child,
        );
      },
    );
  }
}
