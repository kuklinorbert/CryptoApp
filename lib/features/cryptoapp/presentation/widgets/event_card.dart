import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/formatters.dart';
import 'package:flutter/material.dart';

Card buildEventCard(BuildContext context, LoadedEvents state, int i) {
  return Card(
      child: InkWell(
    onTap: () {
      Navigator.of(context)
          .pushNamed('/eventdetails', arguments: state.event.data[i]);
    },
    child: (SizedBox(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? MediaQuery.of(context).size.height * 0.3
          : MediaQuery.of(context).size.height * 0.83,
      width: MediaQuery.of(context).size.width,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Image.network(
          state.event.data[i].screenshot,
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height * 0.22
              : MediaQuery.of(context).size.height * 0.7,
          fit: BoxFit.cover,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(state.event.data[i].title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(children: [
                Icon(
                  Icons.event,
                  color: Colors.blue,
                ),
                Text(
                  formatDate(state.event.data[i].startDate, context),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue),
                )
              ]),
            )
          ],
        ),
      ]),
    )),
  ));
}
