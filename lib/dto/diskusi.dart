class Diskusi{
  final int idDiskusi;
  final int idAlumni;
  final String subjekDiskusi;
  final String isiDiskusi;
  final String tanggal;
  final String namaAlumni;
  final String email;
  final String fotoProfile;
  

  Diskusi({
    required this.idDiskusi,
    required this.idAlumni,
    required this.subjekDiskusi,
    required this.isiDiskusi,
    required this.tanggal,
    required this.namaAlumni,
    required this.email,
    required this.fotoProfile,
  });

  factory Diskusi.fromJson(Map<String, dynamic> json) => Diskusi(
    idDiskusi: json['id_diskusi'] as int,
    idAlumni: json['id_alumni'] as int,
    subjekDiskusi: json['subjek_diskusi'] as String,
    isiDiskusi: json['isi_diskusi'] as String,
    tanggal: json['tanggal'] as String,
    namaAlumni: json['nama_alumni'] as String,
    email: json['email'] as String,
    fotoProfile: json['foto_profile'] as String,
  );
}