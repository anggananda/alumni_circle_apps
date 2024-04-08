import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class DetailEvent extends StatefulWidget {
  const DetailEvent({super.key});

  @override
  State<DetailEvent> createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  final String description =
      "Acara ini bertujuan untuk merayakan hari jadi prodi, menjalin silaturahmi antara alumni dan mahasiswa, serta memperkenalkan prodi kepada masyarakat luas. Terdapat beberapa rangkaian acara yaitu pembukaan, pembacaan doa, laporan ketua panitia, pemotongan tumpeng, sambutan coordinator program studi, pertunjukan seni, penutup. Alumni dapat mendaftarkan diri melalui website atau media sosial program studi. Biaya pendaftaran sebesar Rp50.000,-. Peserta yang telah mendaftar akan mendapatkan e-ticket sebagai bukti pendaftaran. E-ticket dapat ditukarkan dengan konsumsi di lokasi acara. Acara ini merupakan wujud rasa syukur program studi atas dukungan dan kerja keras semua pihak selama 1 tahun. Acara ini juga bertujuan untuk mempererat tali silaturahmi antara alumni dan program studi. Kami tunggu kehadiran Anda!";

  bool _add = false;
  bool _favorite = false;

  void _addEvent() {
    setState(() {
      _add = !_add;
    });
  }

  void _favoriteEvent() {
    setState(() {
      _favorite = !_favorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: const NetworkImage(
                        "https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1587&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: secondaryColor,
                              ),
                              child: const Icon(Icons.arrow_back),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "🌟 Reuni Prodi SI",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: primaryFontColor),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          "Details",
                          style: TextStyle(color: primaryFontColor),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: _addEvent,
                            icon: Icon(
                              Icons.bookmark_add,
                              color: _add == true ? primaryColor : Colors.grey,
                            )),
                        IconButton(
                            onPressed: _favoriteEvent,
                            icon: Icon(
                              Icons.favorite,
                              color:
                                  _favorite == true ? Colors.red : Colors.grey,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Date :',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' 01-01-2025',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    width: 370,
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          color: primaryFontColor,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Location :',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text: ' Lap. FTK Kampus Tengah Undiksha',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  description,
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: primaryFontColor),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                width: 370,
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      color: primaryFontColor,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'CP :',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                          text: ' 082236903868 (dwi angga)',
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
