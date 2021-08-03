import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle defaultStyle1 =
        TextStyle(fontSize: 20, fontWeight: FontWeight.w500);

    TextStyle defaultStyle2 =
        TextStyle(fontSize: 17, fontWeight: FontWeight.w400);

    _storeOnboardInfo() async {
      int isViewed = 1;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('isViewed', isViewed);
      print(prefs.getInt('isViewed'));
    }

    return IntroductionScreen(
      pages: [
        PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                children: [
                  Text(
                    "search".tr(),
                    style: defaultStyle1,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "search_long".tr(),
                    style: defaultStyle2,
                  )
                ],
              ),
            ),
            bodyWidget: Padding(
              padding: EdgeInsets.only(top: 25),
              child: Image.asset(
                'assets/onboarding/search1.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )),
        PageViewModel(
          titleWidget: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(children: [
              Text("favourites".tr(), style: defaultStyle1),
              SizedBox(
                height: 10,
              ),
              Text("favourite_long".tr(), style: defaultStyle2)
            ]),
          ),
          bodyWidget: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              children: [
                Image.asset('assets/onboarding/favourite1.png',
                    width: MediaQuery.of(context).size.width * 0.9),
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/onboarding/favourite2.png',
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ],
            ),
          ),
        ),
        PageViewModel(
            titleWidget: Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(children: [
                Text("events".tr(), style: defaultStyle1),
                SizedBox(
                  height: 10,
                ),
                Text("events_long".tr(), style: defaultStyle2)
              ]),
            ),
            bodyWidget: Padding(
              padding: const EdgeInsets.only(top: 25.0),
              child: Image.asset(
                'assets/onboarding/event.png',
                width: MediaQuery.of(context).size.width * 0.9,
              ),
            )),
      ],
      done: Text("done").tr(),
      skip: Text("skip").tr(),
      next: Text("next").tr(),
      onDone: () {
        _storeOnboardInfo();
        Navigator.of(context).pushReplacementNamed('/auth');
      },
      onSkip: () {
        _storeOnboardInfo();
        Navigator.of(context).pushReplacementNamed('/auth');
      },
      showSkipButton: true,
      showDoneButton: true,
      showNextButton: true,
    );
  }
}
