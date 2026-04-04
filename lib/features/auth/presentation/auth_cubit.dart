import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';


import '../domain/entites/user.dart';
import '../domain/usecases/get_current_user_usecase.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/register_usecase.dart';

// States
part 'auth_state.dart';

// Cubit
class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    final result = await loginUseCase(LoginParams(
      email: email,
      password: password,
    ));

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());

    final result = await registerUseCase(RegisterParams(
      email: email,
      password: password,
      name: name,
    ));

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());

    final result = await logoutUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(AuthUnauthenticated()),
    );
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());

    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
          (failure) => emit(AuthUnauthenticated()),
          (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthUnauthenticated());
        }
      },
    );
  }

  void resetError() {
    if (state is AuthError) {
      emit(AuthUnauthenticated());
    }
  }
}