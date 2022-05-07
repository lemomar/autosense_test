import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fuel_maps/repositories/auth_repository/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;
  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, loginStatus: LoginStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, loginStatus: LoginStatus.initial));
  }

  void login(String email, String password) {
    if (state.loginStatus == LoginStatus.initial) return;
    try {
      emit(state.copyWith(loginStatus: LoginStatus.submitted));
      _authRepository.login(email: state.email, password: state.password);
      emit(state.copyWith(loginStatus: LoginStatus.success));
    } catch (_) {
      emit(state.copyWith(loginStatus: LoginStatus.error));
    }
  }
}
