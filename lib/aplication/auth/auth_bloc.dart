import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/local_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._localRepositoryImpl) : super(AuthInitial());
  final LocalRepository _localRepositoryImpl;

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthCheckRequested) {
      final user = _localRepositoryImpl.getLocalUser();
      if (user != null) {
        yield AuthAuthorized();
      } else {
        yield AuthUnauthorized();
      }
    }
    if (event is SignOut) {
      yield AuthUnauthorized();
    }
  }
}
