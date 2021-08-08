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
  var numberPlus3 = NumberFormat("+#0.000");
  var numberMinus3 = NumberFormat("#0.000");
  var numberPlus5 = NumberFormat("+#0.000##");
  var numberMinus5 = NumberFormat("#0.000##");
  var numberPlus7 = NumberFormat("+#0.000####");
  var numberMinus7 = NumberFormat("#0.000####");

  var formatNum = double.parse(number);

  if (formatNum >= 0) {
    return ((formatNum <= 0.005)
        ? (formatNum <= 0.00005)
            ? numberPlus7.format(formatNum)
            : numberPlus5.format(formatNum)
        : numberPlus3.format(formatNum));
  } else {
    return ((formatNum >= -0.005)
        ? (formatNum >= -0.00005)
            ? numberMinus7.format(formatNum)
            : numberMinus5.format(formatNum)
        : numberMinus3.format(formatNum));
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

String formatDate(DateTime date, BuildContext context) {
  DateFormat dateFormatEN = DateFormat('dd.MM.yyyy');
  DateFormat dateFormatHU = DateFormat('yyyy.MM.dd');
  return (Localizations.localeOf(context).languageCode == 'en')
      ? dateFormatEN.format(date)
      : dateFormatHU.format(date);
}
