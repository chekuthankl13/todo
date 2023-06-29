import 'package:flutter/material.dart';

spaceHeight(h) => SizedBox(
      height: h.toDouble(),
    );

spaceWidth(w) => SizedBox(
      width: w.toDouble(),
    );

sH(context) => MediaQuery.of(context).size.height;

sW(context) => MediaQuery.of(context).size.width;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

errorToast(context, {required error}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        margin: const EdgeInsets.all(5),
      ),
    );
