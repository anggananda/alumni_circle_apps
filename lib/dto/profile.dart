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
