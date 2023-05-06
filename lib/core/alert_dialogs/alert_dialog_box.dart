import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kfupm_football/core/animation/bounce_button.dart';

import '../animation/constant/color.dart';
import '../constants/text_styles.dart';
import '../navigations/navigations.dart';

class AlertDialogBox {
  static Future<bool?> showAssertionDialog(context,
      {String? message,
      bool locale = false,
      String title = '',
      String? continueButton,
      String? cancelButton,
      Color cancelButtonColor = Colors.red,
      Color okButtonColor = Colors.cyan,
      bool preferableChoice = true}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != ''
              ? Text(
                  title,
                  style: h1.copyWith(color: kRed),
                  textAlign: TextAlign.center,
                )
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: kBackground,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (message != null)
                  Center(
                    child: Text(
                      message,
                      style: h1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RoundedButton(
                          title: cancelButton ?? "Cancel",
                          buttonColor: cancelButtonColor,
                          onTap: () {
                            popPage(context);
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: RoundedButton(
                          buttonColor: okButtonColor,
                          title: continueButton ?? "Ok",
                          onTap: () {
                            popPage(context, args: true);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> showAlertDialog(context,
      {String? message,
      bool locale = false,
      String title = '',
      String? continueButton,
      String? cancelButton,
      bool preferableChoice = true}) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != ''
              ? Text(
                  title,
                  style: h1,
                  textAlign: TextAlign.center,
                )
              : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
          backgroundColor: kBackground,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                if (message != null)
                  Center(
                    child: Text(
                      message,
                      style: h1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: RoundedButton(
                          title: continueButton ?? "Ok",
                          onTap: () {
                            popPage(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<dynamic> showCustomDialog(
      {required BuildContext context, required Widget widget, bool dismissible = true, double? width, double? height}) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kBackground,
          content: Container(
            constraints: BoxConstraints(
              minHeight: height != null ? height : MediaQuery.of(context).size.height * 0.7,
              minWidth: width != null ? width : MediaQuery.of(context).size.width * 0.7,
            ),
            child: SingleChildScrollView(child: widget),
          ),
        );
      },
    );
  }

  static Future<T?> showCustomDialogTyped<T>(
      {required BuildContext context, required Widget widget, bool dismissible = true, double? width, double? height}) {
    return showDialog<T?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: kBackground,
          content: Container(
            constraints: BoxConstraints(
              minHeight: height != null ? height : MediaQuery.of(context).size.height * 0.7,
              minWidth: width != null ? width : MediaQuery.of(context).size.width * 0.7,
            ),
            child: SingleChildScrollView(child: widget),
          ),
        );
      },
    );
  }
}
