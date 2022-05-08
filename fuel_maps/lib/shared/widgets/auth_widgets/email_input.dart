import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubits/cubits.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) => context.read<LoginCubit>().emailChanged(value),
          decoration: const InputDecoration(labelText: "Email"),
        );
      },
    );
  }
}

class DisplayNameInput extends StatelessWidget {
  const DisplayNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.displayName != current.displayName,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextFormField(
            onChanged: (value) => context.read<LoginCubit>().displayNameChanged(value),
            decoration: const InputDecoration(labelText: "Display Name"),
          ),
        );
      },
    );
  }
}
