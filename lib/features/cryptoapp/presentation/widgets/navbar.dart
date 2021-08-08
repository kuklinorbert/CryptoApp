import 'package:cryptoapp/features/cryptoapp/presentation/bloc/navigationbar/navigationbar_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

BottomNavigationBar buildNavbar(NavigationbarBloc navbarBloc, int index) {
  return BottomNavigationBar(
    currentIndex: index,
    onTap: (index) {
      if (index == 0) navbarBloc.add(HomeSelected());
      if (index == 1) navbarBloc.add(FavouritesSelected());
      if (index == 2) navbarBloc.add(EventsSelected());
    },
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'.tr()),
      BottomNavigationBarItem(
          icon: Icon(Icons.favorite), label: 'favourites'.tr()),
      BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'events'.tr()),
    ],
  );
}
