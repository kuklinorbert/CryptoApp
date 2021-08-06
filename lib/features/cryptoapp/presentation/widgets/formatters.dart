import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatPercentage(String number) {
  var percentagePlus = NumberFormat("+#0.00%");
  var percentageMinus = NumberFormat("#0.00%");
  var percent = double.parse(number);
  if (percent >= 0) {
    return percentagePlus.format(percent);
  } else {
    return percentageMinus.format(percent);
  }
}

String formatNumber(String number) {
  var numberPlus = NumberFormat("+#0.000");
  var numberMinus = NumberFormat("#0.000");
  var formatNum = double.parse(number);
  if (formatNum >= 0) {
    return numberPlus.format(formatNum);
  } else {
    return numberMinus.format(formatNum);
  }
}

TextStyle styleText(String number) {
  var styleNum = double.parse(number);
  if (styleNum >= 0) {
    return TextStyle(color: Colors.green, fontSize: 18);
  } else {
    return TextStyle(color: Colors.red, fontSize: 18);
  }
}

String formatLongNumber(String number, BuildContext context) {
  var formatLong = NumberFormat.compactLong(
      locale: Localizations.localeOf(context).languageCode);
  var formatNum = double.parse(number);
  return formatLong.format(formatNum);
}
