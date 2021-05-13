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
  late Timer timer;
  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthCheckRequested) {
      final user = _localRepositoryImpl.getLocalUser();
      /*final date= DateTime.parse(user.expireDate as String); 
 
 final diff= date.difference(DateTime.now());
 print (diff.inSeconds);
      timer = Timer.periodic(Duration(seconds:diff.inSeconds),(timer) {
       
      });*/
      if (user.registerMode != -1) {
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
