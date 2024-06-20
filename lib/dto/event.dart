class Events{
  final int idEvent;
  final int idCategory;
  final String namaEvent;
  final String tanggalEvent;
  final String lokasi;
  final String deskripsi;
  final String category;
  final String gambar;
  final double latitude;
  final double longitude;
  

  Events({
    required this.idEvent,
    required this.idCategory,
    required this.namaEvent,
    required this.tanggalEvent,
    required this.lokasi,
    required this.deskripsi,
    required this.category,
    required this.gambar,
    required this.latitude,
    required this.longitude
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    idEvent: json['id_event'] as int,
    idCategory: json['id_kategori'] as int,
    namaEvent: json['nama_event'] as String,
    tanggalEvent: json['tanggal_event'] as String,
    lokasi: json['lokasi'] as String,
    deskripsi: json['deskripsi'] as String,
    category: json['kategori'] as String,
    gambar: json['gambar'] as String,
    latitude: double.parse(json['latitude'] as String), 
    longitude: double.parse(json['longitude'] as String),
  );
}