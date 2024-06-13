import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitialState());

  void setProfile(String roles, int idAlumni){
    emit(ProfileState(roles: roles, idAlumni: idAlumni));
  }
}
