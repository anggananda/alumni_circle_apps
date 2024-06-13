class Replies{
  final int idReply;
  final int idDiskusi;
  final int idAlumni;
  final String isiReply;
  final String tanggal;
  final String namaAlumni;
  final String fotoProfile;
  final String email;
  

  Replies({
    required this.idReply,
    required this.idDiskusi,
    required this.idAlumni,
    required this.isiReply,
    required this.tanggal,
    required this.namaAlumni,
    required this.fotoProfile,
    required this.email,
  });

  factory Replies.fromJson(Map<String, dynamic> json) => Replies(
    idReply: json['id_reply'] as int,
    idDiskusi: json['id_diskusi'] as int,
    idAlumni: json['id_alumni'] as int,
    isiReply: json['isi_reply'] as String,
    tanggal: json['tanggal'] as String,
    namaAlumni: json['nama_alumni'] as String,
    fotoProfile: json['foto_profile'] as String,
    email: json['email'] as String,
  );
}