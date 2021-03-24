import 'package:flutter/foundation.dart';

@immutable
abstract class AuthFailure {
 const AuthFailure.canceledByUser();
 const AuthFailure.serverError();
}
