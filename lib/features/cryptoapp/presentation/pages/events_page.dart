import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                        return Card(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed('/eventdetails',
                                arguments: state.event.data[i]);
                          },
                          child: (SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? MediaQuery.of(context).size.height * 0.3
                                : MediaQuery.of(context).size.height * 0.83,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Image.network(
                                    state.event.data[i].screenshot,
                                    height: MediaQuery.of(context)
                                                .orientation ==
                                            Orientation.portrait
                                        ? MediaQuery.of(context).size.height *
                                            0.22
                                        : MediaQuery.of(context).size.height *
                                            0.7,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(state.event.data[i].title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: Row(children: [
                                          Icon(
                                            Icons.event,
                                            color: Colors.blue,
                                          ),
                                          Text(
                                            state.event.data[i].startDate
                                                .toString()
                                                .substring(0, 10)
                                                .replaceAll("-", "."),
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue),
                                          ),
                                        ]),
                                      )
                                    ],
                                  ),
                                ]),
                          )),
                        ));
                      });
                } else if (state is ErrorEvents) {
                  return Center(
                    child: IconButton(
                        icon: Icon(Icons.refresh),
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
