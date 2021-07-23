import 'package:cryptoapp/features/cryptoapp/domain/usecases/check_auth.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    super.initState();
    authBloc = sl<AuthBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
      bloc: sl<AuthBloc>(),
      listener: (context, state) {
        print(state);
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
      child: BlocBuilder(
        bloc: authBloc..add(CheckAuthEvent()),
        buildWhen: (previous, current) {
          if (current is ErrorLoggedState || current is VerifyErrorState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is Unauthenticated) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You must verify your phone number'),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      phoneNumber = int.parse(value);
                    },
                    onSaved: (String value) {
                      phoneNumber = int.parse(value);
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        authBloc.add(
                            SendCodeEvent(phoneNumber: phoneNumber.toString()));
                      },
                      child: Text('Send code'))
                ]);
          } else if (state is CodeSentState) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('You must enter the code from the SMS'),
                  TextFormField(
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      smsCode = value;
                    },
                    onSaved: (String value) {
                      smsCode = value;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        authBloc.add(VerifyEvent(smsCode: smsCode));
                        //Bloc
                      },
                      child: Text('Verify')),
                  ElevatedButton(
                      onPressed: (resendTimes >= 3)
                          ? null
                          : () {
                              print(resendTimes);
                              resendTimes++;
                              authBloc.add(ResendCodeEvent());
                            },
                      // onPressed: () {
                      //   resendTimes++;
                      //   if (resendTimes == 3) {
                      //     return null;
                      //   } else {
                      //     authBloc.add(ResendCodeEvent());
                      //   }
                      //   //Bloc
                      // },
                      child: Text('Resend Code'))
                ]);
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
