import 'dart:ui';

import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../injection_container.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  int phoneNumber;
  String smsCode;
  AuthBloc authBloc;
  int resendTimes = 0;

  @override
  void initState() {
    authBloc = sl<AuthBloc>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacementNamed('/main');
        } else if (state is ErrorLoggedState) {
          authBloc.add(JumpBackEvent());
          ScaffoldMessenger.of(context)
              .showSnackBar(buildSnackBar(context, state.message));
        } else if (state is VerifyErrorState) {
          authBloc.add(JumpBackEvent());
          ScaffoldMessenger.of(context)
              .showSnackBar(buildSnackBar(context, state.message));
        } else if (state is Unauthenticated) {
          resendTimes = 0;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: sl<AuthBloc>()..add(CheckAuthEvent()),
        buildWhen: (previous, current) {
          if (current is ErrorLoggedState || current is VerifyErrorState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state is Unauthenticated) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "must_verify".tr(),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextFormField(
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                            filled: true,
                            prefix: Text('+'),
                            border: OutlineInputBorder()),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
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
                          authBloc
                            ..add(SendCodeEvent(
                                phoneNumber: phoneNumber.toString()));
                        },
                        child: Text(
                          "send".tr(),
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ))
                  ]),
            );
          } else if (state is CodeSentState) {
            return Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('enter_sms'.tr(), style: TextStyle(fontSize: 20)),
                    SizedBox(height: 40),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: PinPut(
                          textStyle: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                          fieldsCount: 6,
                          eachFieldWidth:
                              MediaQuery.of(context).size.width * 0.1,
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
                            style:
                                TextStyle(color: Colors.blue, fontSize: 18))),
                    TextButton.icon(
                        icon: Icon(
                          Icons.refresh,
                        ),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) =>
                                states.contains(MaterialState.disabled)
                                    ? Colors.grey
                                    : Colors.purple,
                          ),
                        ),
                        onPressed: (resendTimes >= 3)
                            ? null
                            : () {
                                resendTimes++;
                                authBloc.add(ResendCodeEvent());
                              },
                        label: Text(
                          'resend'.tr(),
                          style: TextStyle(fontSize: 16),
                        ))
                  ]),
            );
          } else if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Container();
          }
        },
      ),
    ));
  }
}
