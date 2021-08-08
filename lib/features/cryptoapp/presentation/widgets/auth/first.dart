import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

Center buildFirst(BuildContext context, AuthBloc authBloc) {
  int phoneNumber;
  return Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "must_verify".tr(),
        style: TextStyle(fontSize: 20),
      ),
      SizedBox(height: 40),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: TextFormField(
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
          decoration: InputDecoration(
              filled: true, prefix: Text('+'), border: OutlineInputBorder()),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            phoneNumber = int.parse(value);
          },
          onSaved: (String value) {
            phoneNumber = int.parse(value);
          },
        ),
      ),
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
            authBloc..add(SendCodeEvent(phoneNumber: phoneNumber.toString()));
          },
          child: Text(
            "send".tr(),
            style: TextStyle(color: Colors.blue, fontSize: 18),
          ))
    ]),
  );
}
