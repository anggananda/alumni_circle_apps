import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthInitialState());

  void login(String accessToken, String token){
    emit(AuthState(isLoggedIn: true, accessToken: accessToken, token: token));
  }

  void logout(){
    emit(const AuthState(isLoggedIn: false, accessToken: "", token: ""));
  }
}
