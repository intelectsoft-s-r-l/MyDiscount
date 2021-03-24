import 'package:flutter/foundation.dart';

@immutable
class AuthFailure {
  const AuthFailure.canceledByUser();
  const AuthFailure.serverError();
  const AuthFailure.noInternet();
}
