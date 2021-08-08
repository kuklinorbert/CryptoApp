import 'package:cryptoapp/features/cryptoapp/presentation/bloc/auth/auth_bloc.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/auth/first.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/auth/second.dart';
import 'package:cryptoapp/features/cryptoapp/presentation/widgets/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String smsCode;
  AuthBloc authBloc;

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
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        bloc: authBloc..add(CheckAuthEvent()),
        buildWhen: (previous, current) {
          if (current is ErrorLoggedState || current is VerifyErrorState) {
            return false;
          } else {
            return true;
          }
        },
        builder: (context, state) {
          if (state is Unauthenticated) {
            return buildFirst(context, authBloc);
          } else if (state is CodeSentState) {
            return buildSecond(context, authBloc);
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
