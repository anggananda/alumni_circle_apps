class ListEvents{
  final int idListEvent;
  final String namaEvent;
  final String tanggalEvent;
  final String lokasi;
  final String deskripsi;
  final String gambar;
  

  ListEvents({
    required this.idListEvent,
    required this.namaEvent,
    required this.tanggalEvent,
    required this.lokasi,
    required this.deskripsi,
    required this.gambar,
  });

  factory ListEvents.fromJson(Map<String, dynamic> json) => ListEvents(
    idListEvent: json['id_listevent'] as int,
    namaEvent: json['nama_event'] as String,
    tanggalEvent: json['tanggal_event'] as String,
    lokasi: json['lokasi'] as String,
    deskripsi: json['deskripsi'] as String,
    gambar: json['gambar'] as String,
  );
}