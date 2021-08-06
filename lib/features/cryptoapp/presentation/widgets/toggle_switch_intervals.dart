import 'package:cryptoapp/features/cryptoapp/presentation/bloc/interval/interval_bloc.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class buildSwitchInterval extends StatelessWidget {
  const buildSwitchInterval({
    Key key,
    @required this.intervalBloc,
  }) : super(key: key);

  final IntervalBloc intervalBloc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleSwitch(
        totalSwitches: 5,
        initialLabelIndex: intervalBloc.index,
        borderColor: [Colors.blue],
        inactiveBgColor: Colors.grey[200],
        borderWidth: 2,
        cornerRadius: 25,
        labels: ['1D', '7D', '30D', '365D', 'ytd'],
        onToggle: (index) {
          intervalBloc.add(SwitchIntervalEvent(interval: index));
        },
      ),
    );
  }
}