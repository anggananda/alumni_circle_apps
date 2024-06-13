class Events{
  final int idEvent;
  final String namaEvent;
  final String tanggalEvent;
  final String lokasi;
  final String deskripsi;
  final String gambar;
  

  Events({
    required this.idEvent,
    required this.namaEvent,
    required this.tanggalEvent,
    required this.lokasi,
    required this.deskripsi,
    required this.gambar,
  });

  factory Events.fromJson(Map<String, dynamic> json) => Events(
    idEvent: json['id_event'] as int,
    namaEvent: json['nama_event'] as String,
    tanggalEvent: json['tanggal_event'] as String,
    lokasi: json['lokasi'] as String,
    deskripsi: json['deskripsi'] as String,
    gambar: json['gambar'] as String,
  );
}