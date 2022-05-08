import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/app/app_bloc.dart';
import '../../cubits/cubits.dart';
import '../../repositories/repositories.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfileView());

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppBloc>();
    final user = context.select((AppBloc bloc) => bloc.state.user);
    final String displayName = user.name ?? "";
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome, $displayName"),
            ElevatedButton(
              onPressed: () => context.read<AppBloc>().add(AppLogoutRequested()),
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }
}

class Login extends StatelessWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  static Page page() => const MaterialPage<void>(child: Login());

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
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                EmailInput(),
                DisplayNameInput(),
                PasswordInput(),
                LoginButton(),
                RegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
        return TextFormField(
          onChanged: (value) => context.read<LoginCubit>().displayNameChanged(value),
          decoration: const InputDecoration(labelText: "Display Name"),
        );
      },
    );
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) => context.read<LoginCubit>().passwordChanged(value),
          decoration: const InputDecoration(labelText: "Password"),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        final state = context.read<LoginCubit>().state;
        if (state.loginStatus == LoginStatus.submitted) return const CircularProgressIndicator();
        if (state.loginStatus == LoginStatus.success) return const Icon(Icons.check);
        return ElevatedButton(
          onPressed: () => context.read<LoginCubit>().login(state.email, state.password),
          child: const Text("Login"),
        );
      },
    );
  }
}

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
        return ElevatedButton(
          onPressed: () => context.read<LoginCubit>().register(state.email, state.password),
          child: const Text("Register"),
        );
      },
    );
  }
}
