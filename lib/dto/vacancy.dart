class Vacancies{
  final int idVacancy;
  final String namaVacancy;
  final String deskripsi;
  final String gambar;
  

  Vacancies({
    required this.idVacancy,
    required this.namaVacancy,
    required this.deskripsi,
    required this.gambar,
  });

  factory Vacancies.fromJson(Map<String, dynamic> json) => Vacancies(
    idVacancy: json['id_vacancy'] as int,
    namaVacancy: json['nama_vacancy'] as String,
    deskripsi: json['deskripsi'] as String,
    gambar: json['gambar'] as String,
  );
}