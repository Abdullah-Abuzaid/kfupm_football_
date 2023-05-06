import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import '../animation/constant/color.dart';

enum ProgressDialogType { Normal, Download }

double _maxProgress = 100.0;

Widget? _customBody;
const Color kTransparent = Colors.transparent;

Alignment _progressWidgetAlignment = Alignment.centerLeft;

bool? _isShowing = false;
BuildContext? _context, _dismissingContext;
bool _barrierDismissible = true, _showLogs = false;

double _dialogElevation = 8.0, _borderRadius = 8.0;
Color _backgroundColor = Colors.white;
Curve _insetAnimCurve = Curves.easeInOut;
EdgeInsets _dialogPadding = const EdgeInsets.all(8.0);

class ProgressDialog {
  _Body? _dialog;

  ProgressDialog(BuildContext? context,
      {ProgressDialogType? type, bool? isDismissible, bool? showLogs, Widget? customBody}) {
    _context = context;
    _barrierDismissible = isDismissible ?? true;
    _showLogs = showLogs ?? false;
    _customBody = customBody ?? null;
  }

  void style(
      {Widget? child,
      double? progress,
      double? maxProgress,
      String? message,
      Widget? progressWidget,
      Color? backgroundColor,
      TextStyle? progressTextStyle,
      TextStyle? messageTextStyle,
      double? elevation,
      TextAlign? textAlign,
      double? borderRadius,
      Curve? insetAnimCurve,
      EdgeInsets? padding,
      Alignment? progressWidgetAlignment}) {
    if (_isShowing!) return;

    _maxProgress = maxProgress ?? _maxProgress;

    _backgroundColor = backgroundColor ?? _backgroundColor;
    _dialogElevation = elevation ?? _dialogElevation;
    _borderRadius = borderRadius ?? _borderRadius;
    _insetAnimCurve = insetAnimCurve ?? _insetAnimCurve;

    _dialogPadding = padding ?? _dialogPadding;
    _progressWidgetAlignment = progressWidgetAlignment ?? _progressWidgetAlignment;
  }

  void update({
    double? progress,
    double? maxProgress,
    Widget? progressWidget,
  }) {
    _maxProgress = maxProgress ?? _maxProgress;

    if (_isShowing!) _dialog!.update();
  }

  bool? isShowing() {
    return _isShowing;
  }

  Future<bool> hide() async {
    try {
      if (_isShowing ?? false) {
        _isShowing = false;
        if (Navigator.of(_dismissingContext!).canPop()) Navigator.of(_dismissingContext!).pop();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  Future<bool> show() async {
    try {
      if (_isShowing == null) _isShowing = false;
      if (!_isShowing!) {
        _dialog = new _Body();
        showDialog<dynamic>(
          context: _context!,
          barrierDismissible: false, //_barrierDismissible,
          builder: (BuildContext context) {
            _dismissingContext = context;
            return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: Center(child: _dialog),
            );
          },
        );
        // Delaying the function for 200 milliseconds
        // [Default transitionDuration of DialogRoute]
        await Future.delayed(Duration(milliseconds: 200));
        if (_showLogs) debugPrint('ProgressDialog shown');
        _isShowing = true;
        return true;
      } else {
        if (_showLogs) debugPrint("ProgressDialog already shown/showing");
        return false;
      }
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  _BodyState _dialog = _BodyState();

  update() {
    _dialog.update();
  }

  Future<bool> hide() async {
    try {
      if (_isShowing!) {
        _isShowing = false;
        if (Navigator.of(_dismissingContext!).canPop()) Navigator.of(_dismissingContext!).pop();
        if (_showLogs) debugPrint('ProgressDialog dismissed');
        return Future.value(true);
      } else {
        if (_showLogs) debugPrint('ProgressDialog already dismissed');
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('Seems there is an issue hiding dialog');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _dialog;
  }
}

class _BodyState extends State<_Body> {
  bool isCancelShown = false;

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    _isShowing = null;
    if (_showLogs) debugPrint('ProgressDialog dismissed by back button');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 5)).then((value) {
      if (_isShowing != null) {
        isCancelShown = true;

        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kTransparent,
      child: _customBody ??
          Container(
            padding: _dialogPadding,
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Dialog(
                    backgroundColor: kTransparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const SizedBox(width: 8.0),
                    Align(
                      alignment: _progressWidgetAlignment,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        width: 200.0,
                        height: 200.0,
                        child: RefreshProgressIndicator(
                          backgroundColor: kBackground,
                          strokeWidth: 10,
                          color: kCyan,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                  ],
                ),
                Visibility(
                  visible: isCancelShown,
                  child: RoundedButton(
                    title: "cancel",
                    onTap: () => widget.hide(),
                  ),
                )
              ],
            ),
          ),
    );
  }
}
