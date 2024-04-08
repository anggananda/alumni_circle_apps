import 'package:flutter/material.dart';

class EventCount {
  final String title;
  final String preview;
  final VoidCallback onPressed;
  final String img; // Tambahkan properti img

  EventCount({required this.title, required this.preview,required this.onPressed, required this.img});
}

List<EventCount> getEventCounts(BuildContext context) {
  return [
    EventCount(
      title: "Reuni Prodi SI",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://images.unsplash.com/photo-1511895426328-dc8714191300?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    EventCount(
      title: "Ulang Tahun",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://images.unsplash.com/photo-1558636508-e0db3814bd1d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    EventCount(
      title: "Seminar Nasional",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    EventCount(
      title: "Bakti Sosial",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?q=80&w=1585&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    ),
    EventCount(
      title: "Turnamen Olahraga",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://images.unsplash.com/photo-1630420598913-44208d36f9af?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZnV0c2FsfGVufDB8fDB8fHww',
    ),
    EventCount(
      title: "Pelatihan Digital Marketing",
      preview: "Reuni angkatan 2018 Prodi Sistem Informasi Universitas Pendidikan Ganesha: 1 tahun kelulusan, 12 Desember 2023. Acara: registrasi, sambutan, seminar nasional, penutupan dengan pelepasan balon.",
      onPressed: () => Navigator.pushNamed(context, '/detailevent'),
      img: 'https://plus.unsplash.com/premium_photo-1663100604353-50fd87e5133e?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fHBlbGF0aWhhbiUyMGRpZ2l0YWwlMjBtYXJrZXRpbmd8ZW58MHx8MHx8fDA%3D',
    ),
  ];
}
