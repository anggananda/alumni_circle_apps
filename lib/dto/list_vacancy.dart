class ListVacancy{
  final int idListVacancy;
  final String namaVacancy;
  final String deskripsi;
  final String gambar;
  

  ListVacancy({
    required this.idListVacancy,
    required this.namaVacancy,
    required this.deskripsi,
    required this.gambar,
  });

  factory ListVacancy.fromJson(Map<String, dynamic> json) => ListVacancy(
    idListVacancy: json['id_listvc'] as int,
    namaVacancy: json['nama_vacancy'] as String,
    deskripsi: json['deskripsi'] as String,
    gambar: json['gambar'] as String,
  );
}