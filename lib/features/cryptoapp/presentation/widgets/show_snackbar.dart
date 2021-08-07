import 'package:flutter/material.dart';

SnackBar buildSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  return SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
    duration: const Duration(milliseconds: 4000),
    width: MediaQuery.of(context).size.width / 1.3,
    padding: const EdgeInsets.symmetric(horizontal: 5),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.black.withOpacity(0.7),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
