part of 'profile_cubit.dart';

@immutable
class ProfileState {
  final String roles;
  final int idAlumni;

  const ProfileState({required this.roles, required this.idAlumni});
}

final class ProfileInitialState extends ProfileState {
  const ProfileInitialState() : super(roles: 'umum', idAlumni: 0);
}
