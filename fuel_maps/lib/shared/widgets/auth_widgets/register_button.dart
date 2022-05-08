import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.loginStatus != current.loginStatus &&
          (current.loginStatus == LoginStatus.submitted || previous.loginStatus == LoginStatus.submitted),
      builder: (context, state) {
        final state = context.read<LoginCubit>().state;
        if (state.loginStatus == LoginStatus.submitted) return const CircularProgressIndicator();
        if (state.loginStatus == LoginStatus.success) return const Icon(Icons.check);
        return TextButton(
          onPressed: () => context.read<LoginCubit>().register(state.email, state.password),
          child: const Text("Register"),
        );
      },
    );
  }
}
