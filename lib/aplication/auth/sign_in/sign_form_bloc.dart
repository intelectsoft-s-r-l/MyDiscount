import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../core/internet_connection_service.dart';
import '../../../domain/entities/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';

part 'sign_form_event.dart';
part 'sign_form_state.dart';

@injectable
class SignFormBloc extends Bloc<SignFormEvent, SignFormState> {
  SignFormBloc(
    this._authRepositoryImpl,
    this.network,
  ) : super(SignFormInitial());
  final AuthRepository? _authRepositoryImpl;
  final NetworkConnection? network;

  @override
  Stream<SignFormState> mapEventToState(
    SignFormEvent event,
  ) async* {
    try {
      if (event is SignInWithGoogle) {
        if (await network!.isConnected) {
          final user = await _authRepositoryImpl!.authenticateWithGoogle();
          if (user != null) {
            yield SignFormDone(user);
          } else {
            yield const SignInError();
          }
        } else {
          yield const SignInNetError();
        }
      }
      if (event is SignInWithFacebook) {
        if (await network!.isConnected) {
          final user = await _authRepositoryImpl!.authenticateWithFacebook();
          if (user != null) {
            yield SignFormDone(user);
          } else {
            yield const SignInError();
          }
        } else {
          yield const SignInNetError();
        }
      }
      if (event is SignInWithApple) {
        if (await network!.isConnected) {
          final user = await _authRepositoryImpl!.authenticateWithApple();
          if (user != null) {
            yield SignFormDone(user);
          } else {
            throw Exception();
          }
        } else {
          yield const SignInNetError();
        }
      }
      if (event is SignOutEvent) {
        _authRepositoryImpl!.logOut();
        yield SignFormInitial();
      }
    } catch (e) {
      yield const SignInError();
    }
  }
}
