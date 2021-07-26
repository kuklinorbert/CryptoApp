import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/events/events_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

Scaffold buildEventsPage(AuthBloc authBloc, NavigationbarBloc navbarBloc) {
  return Scaffold(
    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.only(top: 50, left: 15),
        children: [
          Text(FirebaseAuth.instance.currentUser.phoneNumber),
          Divider(),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              authBloc.add(LogoutEvent());
            },
          )
        ],
      ),
    ),
    appBar: AppBar(
      title: Text('CryptoApp'),
    ),
    body: BlocListener<AuthBloc, AuthState>(
        bloc: authBloc,
        listener: (context, state) {
          if (state is Unauthenticated) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/auth', (route) => false);
          }
        },
        child: BlocBuilder<EventsBloc, EventsState>(
            bloc: sl<EventsBloc>()..add(GetEventsEvent()),
            buildWhen: (previous, current) {
              if (previous is Loaded) {
                return false;
              } else {
                return true;
              }
            },
            builder: (context, state) {
              print(state);
              if (state is EventsInitial) {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Events')]),
                );
              } else if (state is Loading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is Loaded) {
                return ListView.builder(
                    itemCount: state.event.count,
                    itemBuilder: (_, i) {
                      return Card(
                          child: InkWell(
                        onTap: () {},
                        child: (SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Image.network(
                                  state.event.data[i].screenshot,
                                  height:
                                      MediaQuery.of(context).size.height * 0.22,
                                  //width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(state.event.data[i].title,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Text(
                                        state.event.data[i].startDate
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        )),
                      ));
                    });
              } else {
                return Container();
              }
            })),
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: 2,
      onTap: (index) {
        if (index == 0) navbarBloc.add(HomeSelected());
        if (index == 1) navbarBloc.add(FavouritesSelected());
        if (index == 2) navbarBloc.add(EventsSelected());
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), label: 'Favourites'),
        BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Events'),
      ],
    ),
  );
}
