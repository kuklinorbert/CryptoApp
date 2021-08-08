import 'package:cryptoapp/features/cryptoapp/presentation/bloc/converter/converter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

Center buildSwitchCurrencies(
    ConverterBloc converterBloc, String itemId, bool switchNum) {
  return Center(
    child: ToggleSwitch(
      activeFgColor: Colors.white,
      activeBgColor: [Colors.green],
      inactiveBgColor: Colors.grey[300],
      totalSwitches: 2,
      cornerRadius: 25,
      initialLabelIndex: switchNum ? 1 : 0,
      labels: ['\$', '€'],
      onToggle: (index) {
        if (index == 0) {
          converterBloc.add(SwitchToUsdEvent());
        } else {
          converterBloc.add(SwitchToEurEvent(itemId: itemId));
        }
      },
    ),
  );
}
