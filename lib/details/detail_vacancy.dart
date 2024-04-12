import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class DetailVacancy extends StatefulWidget {
  const DetailVacancy({super.key});

  @override
  State<DetailVacancy> createState() => _DetailVacancyState();
}

class _DetailVacancyState extends State<DetailVacancy> {
  final String description =
      "Apakah Anda seorang profesional yang bersemangat dan berorientasi pada tujuan? Apakah Anda mencari kesempatan untuk bekerja di perusahaan yang inovatif dan berkembang pesat? Jika ya, maka kami mengundang Anda untuk bergabung dengan tim kami! Saat ini, kami sedang mencari posisi khusus yang terlampir di poster, untuk bergabung dengan tim kami. Jika Anda memiliki skill dan pengalaman yang berhubungan dengan posisi tersebut kami sangat senang untuk mendengar dari Anda. Silakan kirimkan resume dan surat lamaran Anda ke alamat yang sudah disediakan Mari bergabung bersama kami dan buat perbedaan! ";

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
                        "https://plus.unsplash.com/premium_photo-1661337178354-86e24a57922d?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
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
                          "🌟 Software Engineer",
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
            ],
          ),
        ),
      ),
    );
  }
}
