import 'package:flutter/cupertino.dart';

import 'flush_bar.dart';

class TopNotification {
  String? message;
  Widget? customWidget;
  int? animationDuration;
  int? autoDismissDelay;
  Curve? curve;
  bool? dismissible;
  bool? autoDismissible;
  BuildContext context;
  TopNotification({
    required this.message,
    this.animationDuration,
    this.autoDismissDelay,
    this.curve,
    this.dismissible,
    this.autoDismissible,
    required this.context,
  }) {
    showFlushBar(this.context);
  }
  TopNotification.customWidget({
    required this.customWidget,
    this.animationDuration,
    this.autoDismissDelay,
    this.curve,
    this.dismissible,
    this.autoDismissible,
    required this.context,
  }) {
    showFlushBar(this.context);
  }

  showFlushBar(context) {
    OverlayEntry? flushBar;

    flushBar = OverlayEntry(builder: ((context) {
      return message != null
          ? FlushBar(
              context: context,
              overlayEntry: flushBar,
              message: message,
              curve: curve,
              animationDuration: animationDuration,
              autoDismissDelay: autoDismissDelay,
              dismissible: dismissible,
            )
          : FlushBar.custom(
              context: context,
              overlayEntry: flushBar,
              customWidget: customWidget,
              curve: curve,
              animationDuration: animationDuration,
              autoDismissDelay: autoDismissDelay,
              dismissible: dismissible,
            );
    }));
    Overlay.of(context)!.insert(flushBar);
  }
}
