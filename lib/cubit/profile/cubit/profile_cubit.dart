import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileInitialState());

  void setProfile(String roles, int idAlumni) async {
    // Periksa apakah roles dan idAlumni valid
    if (roles.isEmpty && idAlumni == 0) {
      // Baca idAlumni dari secure storage
      final idAlumniString =
          await SecureStorageUtil.storage.read(key: 'idAlumni');

      // Cek apakah idAlumniString bukan null dan konversi ke int
      if (idAlumniString != null) {
        final parsedIdAlumni = int.tryParse(idAlumniString);
        if (parsedIdAlumni != null) {
          idAlumni = parsedIdAlumni;
        } else {
          debugPrint('Error: idAlumniString is not a valid integer');
          return; // Berhenti jika idAlumni tidak valid
        }
      } else {
        debugPrint('Error: idAlumniString is null');
        return; // Berhenti jika idAlumniString null
      }

      // Baca roles dari secure storage
      final rolesString = await SecureStorageUtil.storage.read(key: 'roles');
      if (rolesString != null) {
        roles = rolesString;
      } else {
        debugPrint('Error: rolesString is null');
        return; // Berhenti jika rolesString null
      }
    }

    // Emit state baru
    emit(ProfileState(roles: roles, idAlumni: idAlumni));
  }
}
