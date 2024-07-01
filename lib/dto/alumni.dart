class Alumni {
  final int idAlumni;
  final String? namaALumni;
  final String? jenisKelamin;
  final String? alamat;
  final String? email;
  final String? tanggalLulus;
  final String? angkatan;
  final String? statusPekerjaan;
  final String username;
  final String password;
  final String roles;
  final String fotoProfile;

  Alumni({
    required this.idAlumni,
    this.namaALumni,
    this.jenisKelamin,
    this.alamat,
    this.email,
    this.tanggalLulus,
    this.angkatan,
    this.statusPekerjaan,
    required this.username,
    required this.password,
    required this.roles,
    required this.fotoProfile,
  });

  factory Alumni.fromJson(Map<String, dynamic> json) => Alumni(
        idAlumni: json['id_alumni'] as int,
        namaALumni: json['nama_alumni'] as String?,
        jenisKelamin: json['jenis_kelamin'] as String?,
        alamat: json['alamat'] as String?,
        email: json['email'] as String?,
        tanggalLulus: json['tanggal_lulus'] as String?,
        angkatan: json['angkatan'] as String?,
        statusPekerjaan: json['status_pekerjaan'] as String?,
        username: json['username'] as String,
        password: json['password'] as String,
        roles: json['roles'] as String,
        fotoProfile: json['foto_profile'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id_alumni': idAlumni,
        'nama_alumni': namaALumni,
        'jenis_kelamin': jenisKelamin,
        'alamat': alamat,
        'email': email,
        'tanggal_lulus': tanggalLulus,
        'angkatan': angkatan,
        'status_pekerjaan': statusPekerjaan,
        'username': username,
        'password': password,
        'roles': roles,
        'foto_profile': fotoProfile,
      };

  factory Alumni.fromMap(Map<String, dynamic> map) => Alumni(
        idAlumni: map['id_alumni'] as int,
        namaALumni: map['nama_alumni'] as String?,
        jenisKelamin: map['jenis_kelamin'] as String?,
        alamat: map['alamat'] as String?,
        email: map['email'] as String?,
        tanggalLulus: map['tanggal_lulus'] as String?,
        angkatan: map['angkatan'] as String?,
        statusPekerjaan: map['status_pekerjaan'] as String?,
        username: map['username'] as String,
        password: map['password'] as String,
        roles: map['roles'] as String,
        fotoProfile: map['foto_profile'] as String,
      );
}
