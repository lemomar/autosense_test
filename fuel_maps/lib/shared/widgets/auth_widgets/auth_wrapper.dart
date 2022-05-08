import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';
import '../../../repositories/repositories.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(context.read<AuthRepository>()),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if ([
            LoginStatus.error,
            LoginStatus.userNotFound,
            LoginStatus.wrongPassword,
            LoginStatus.invalidEmail,
            LoginStatus.weakPassword,
          ].contains(state.loginStatus)) {
            late String message;
            switch (state.loginStatus) {
              case LoginStatus.userNotFound:
                message = "That user does not exist. Did you create an account yet?";
                break;
              case LoginStatus.error:
                message = "An error occured. Please check your credentials and try again";
                break;
              case LoginStatus.wrongPassword:
                message = "The password you provided is invalid.";
                break;
              case LoginStatus.invalidEmail:
                message = "The email address is badly formatted.";
                break;
              case LoginStatus.weakPassword:
                message = "Password should be at least 6 characters.";
                break;
              default:
                break;
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
