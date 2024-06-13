// class Profile {
//   String roles;
//   String message;
//   int idAlumni;

//   Profile({required this.roles, required this.message, required this.idAlumni});

//   factory Profile.fromJson(Map<String, dynamic> json) => Profile(
//       roles: json['roles'] as String, 
//       message: json['message'] as String, 
//       idAlumni: json['id_alumni'] as int);
// }

class Profile {
  final String roles;
  final int idAlumni;

  Profile({required this.roles, required this.idAlumni});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      roles: json['roles'],
      idAlumni: json['id_alumni'],
    );
  }
}
