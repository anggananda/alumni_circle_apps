class Question{
  final int idPertanyaan;
  final int idAlumni;
  final String isiPertanyaan;
  final String tanggal;
  final String namaAlumni;
  final String email;
  final String fotoProfile;

  Question({
    required this.idPertanyaan,
    required this.idAlumni,
    required this.isiPertanyaan,
    required this.tanggal,
    required this.namaAlumni,
    required this.email,
    required this.fotoProfile,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    idPertanyaan: json['id_pertanyaan'] as int,
    idAlumni: json['id_alumni'] as int,
    isiPertanyaan: json['isi_pertanyaan'] as String,
    tanggal: json['tanggal'] as String,
    namaAlumni: json['nama_alumni'] as String,
    email: json['email'] as String,
    fotoProfile: json['foto_profile'] as String,
    
  );
}