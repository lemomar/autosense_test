import 'package:flutter/material.dart';
import 'package:fuel_maps/shared/shared.dart';

class Login extends StatelessWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthWrapper(
      child: LoginBody(),
    );
  }
}

class LoginBody extends StatelessWidget {
  const LoginBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DialogTitle("Authenticate"),
        const DialogSubtitle(
          "Authenticate in order to create stations and see the one you have already created.",
        ),
        const SizedBox(height: 12.0),
        const EmailInput(),
        const PasswordInput(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            RegisterButton(),
            LoginButton(),
          ],
        ),
      ],
    );
  }
}
