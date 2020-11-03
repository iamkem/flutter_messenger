import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messio_app/Repository/AuthRepository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event,) async* {
    if (event is AppLaunchAuthEvent) {
      yield* _mapAppLaunchAuthEventToState();
    } else if (event is GoogleLoginAuthEvent) {
      yield* _mapGoogleLoginAuthEventToState();
    } else if (event is LogoutAuthEvent) {
      yield* _mapLogoutAuthEventToState();
    }
  }

  Stream<AuthState> _mapAppLaunchAuthEventToState() async* {
    yield AuthProgress();
    if (await _authRepository.isLoggedIn()) {
      yield const AuthSuccess(null);
    } else {
      yield AuthFail();
    }
  }

  Stream<AuthState> _mapGoogleLoginAuthEventToState() async* {
    final user = await _authRepository.signInWithGoogle();
    if (user != null) {
      try {
        yield AuthSuccess(user);
      } catch (e) {
        yield AuthFail();
      }
    } else {
      yield AuthFail();
    }
  }

  Stream<AuthState> _mapLogoutAuthEventToState() async* {
    await _authRepository.signOut();
    yield AuthFail();
  }
}
