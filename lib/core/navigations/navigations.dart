import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

dynamic popPage(BuildContext context, {args}) async {
  return await Navigator.maybePop(context, args);
}

dynamic pushPage(BuildContext context, Widget widget) async {
  return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}

dynamic replacePage(BuildContext context, Widget widget) async {
  popPage(context);
  return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ));
}
