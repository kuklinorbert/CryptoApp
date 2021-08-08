import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/event_card.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../injection_container.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key, @required this.authBloc}) : super(key: key);

  final AuthBloc authBloc;

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin {
  EventsBloc eventsBloc = sl<EventsBloc>();

  DateFormat dateFormat = DateFormat('dd.MM.yyyy');

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<AuthBloc, AuthState>(
        bloc: widget.authBloc,
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/auth', (route) => false);
          }
        },
        child: BlocListener<EventsBloc, EventsState>(
          bloc: eventsBloc,
          listener: (context, state) {
            if (state is ErrorEvents) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(buildSnackBar(context, state.message));
            }
          },
          child: BlocBuilder<EventsBloc, EventsState>(
              bloc: eventsBloc..add(GetEventsEvent()),
              buildWhen: (previous, current) {
                if (previous is LoadedEvents) {
                  return false;
                } else {
                  return true;
                }
              },
              builder: (context, state) {
                if (state is LoadingEvents) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is LoadedEvents) {
                  return ListView.builder(
                      itemCount: state.event.count,
                      itemBuilder: (_, i) {
                        return buildEventCard(context, state, i);
                      });
                } else if (state is ErrorEvents) {
                  return Center(
                    child: IconButton(
                        icon: Icon(Icons.refresh, size: 35),
                        onPressed: () {
                          eventsBloc.add(GetEventsEvent());
                        }),
                  );
                } else {
                  return Container();
                }
              }),
        ));
  }
}
