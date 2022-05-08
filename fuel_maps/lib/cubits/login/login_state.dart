// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_cubit.dart';

enum LoginStatus {
  initial,
  success,
  error,
  submitted,
  userNotFound,
  wrongPassword,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
}

class LoginState extends Equatable {
  final String email;
  final String password;
  final String displayName;
  final LoginStatus loginStatus;
  const LoginState({required this.email, required this.password, required this.displayName, required this.loginStatus});

  factory LoginState.initial() {
    return const LoginState(
      email: '',
      password: '',
      displayName: '',
      loginStatus: LoginStatus.initial,
    );
  }

  @override
  List<Object> get props => [email, password, displayName, loginStatus];

  LoginState copyWith({
    String? email,
    String? password,
    String? displayName,
    LoginStatus? loginStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      password: password ?? this.password,
      loginStatus: loginStatus ?? this.loginStatus,
    );
  }
}
