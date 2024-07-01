part of 'auth_cubit.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? token;
  const AuthState({required this.isLoggedIn, this.accessToken, this.token});
}

class AuthInitialState extends AuthState {
  const AuthInitialState() : super(isLoggedIn: true, accessToken: "", token: "");
}
