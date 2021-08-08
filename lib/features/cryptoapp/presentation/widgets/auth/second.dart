import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:easy_localization/easy_localization.dart';

Center buildSecond(BuildContext context, AuthBloc authBloc) {
  String smsCode;
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text('enter_sms'.tr(), style: TextStyle(fontSize: 20)),
      SizedBox(height: 40),
      SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: PinPut(
            textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            fieldsCount: 6,
            eachFieldWidth: MediaQuery.of(context).size.width * 0.1,
            selectedFieldDecoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200]),
            followingFieldDecoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey[200]),
            submittedFieldDecoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(10.0)),
            onChanged: (String value) {
              smsCode = value;
            },
            onSaved: (String value) {
              smsCode = value;
            },
          )),
      SizedBox(
        height: 30,
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              primary: Colors.white,
              side: BorderSide(color: Colors.blue)),
          onPressed: () {
            authBloc.add(VerifyEvent(smsCode: smsCode));
          },
          child: Text('verify'.tr(),
              style: TextStyle(color: Colors.blue, fontSize: 18))),
      TextButton.icon(
          icon: Icon(
            Icons.refresh,
          ),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) =>
                  states.contains(MaterialState.disabled)
                      ? Colors.grey
                      : Colors.purple,
            ),
          ),
          onPressed: (authBloc.resendTimes >= 3)
              ? null
              : () {
                  authBloc.resendTimes++;
                  authBloc.add(ResendCodeEvent());
                },
          label: Text(
            'resend'.tr(),
            style: TextStyle(fontSize: 16),
          ))
    ]),
  );
}
