import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_model.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../infrastructure/core/internet_connection_service.dart';

part 'sign_form_event.dart';
part 'sign_form_state.dart';

@injectable
class SignFormBloc extends Bloc<SignFormEvent, SignFormState> {
  SignFormBloc(
    this._authRepositoryImpl,
    this.network,
  ) : super(SignFormInitial());
  final AuthRepository _authRepositoryImpl;
  final NetworkConnection network;

  @override
  Stream<SignFormState> mapEventToState(
    SignFormEvent event,
  ) async* {
    if (event is SignInWithGoogle) {
      if (await network.isConnected) {
        final function = _authRepositoryImpl.authenticateWithGoogle();
        yield* mapUserToState(function);
      } else {
        yield const SignInNetError();
      }
    }
    if (event is SignInWithFacebook) {
      if (await network.isConnected) {
        yield* mapUserToState(_authRepositoryImpl.authenticateWithFacebook());
      } else {
        yield const SignInNetError();
      }
    }
    if (event is SignInWithApple) {
      if (await network.isConnected) {
        yield* mapUserToState(_authRepositoryImpl.authenticateWithApple());
      } else {
        yield const SignInNetError();
      }
    }
    if (event is SignOutEvent) {
      _authRepositoryImpl.logOut();
      yield SignFormInitial();
    }
  }

  Stream<SignFormState> mapUserToState(Future<User> authFunction) async* {
    final user = await authFunction;
    if (!user.isEmpty) {
      yield SignFormDone(user);
    } else {
      throw Exception();
    }
  }
}
