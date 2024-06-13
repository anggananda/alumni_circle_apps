part of 'auth_cubit.dart';

@immutable
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  const AuthState({required this.isLoggedIn, this.accessToken});
}

final class AuthInitialState extends AuthState {
  const AuthInitialState() : super(isLoggedIn: true, accessToken: "");
}
