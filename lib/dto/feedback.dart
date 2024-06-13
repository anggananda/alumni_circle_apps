class FeedBacks {
  final int idFeedback;
  final int idAlumni;
  final String isiFeedback;
  final String tanggal;
  final String namaAlumni;
  final String email;
  final String fotoProfile;

  FeedBacks({
    required this.idFeedback,
    required this.idAlumni,
    required this.isiFeedback,
    required this.tanggal,
    required this.namaAlumni,
    required this.email,
    required this.fotoProfile,
  });

  factory FeedBacks.fromJson(Map<String, dynamic> json) => FeedBacks(
    idFeedback: json['id_feedback'] as int,
    idAlumni: json['id_alumni'] as int,
    isiFeedback: json['isi_feedback'] as String? ?? '',
    tanggal: json['tanggal'] as String? ?? '',
    namaAlumni: json['nama_alumni'] as String? ?? '',
    email: json['email'] as String? ?? '',
    fotoProfile: json['foto_profile'] as String? ?? '',
  );
}
