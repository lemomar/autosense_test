import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final state = context.read<LoginCubit>().state;
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary,
            onPrimary: Theme.of(context).colorScheme.onPrimary,
          ),
          onPressed: () => context.read<LoginCubit>().login(state.email, state.password),
          child: const Text("Login"),
        );
      },
    );
  }
}
