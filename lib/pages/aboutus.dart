import 'package:flutter/material.dart';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final introAboutUs =
      "Elevate your alumni network with our dedicated SI alumni app. Reconnect, collaborate, and succeed effortlessly.";
  final detailDescription =
      "Welcome to our Alumni App for the Information Systems program! Designed exclusively for alumni of our university's Information Systems program, our platform aims to enhance the alumni network while facilitating the exchange of experiences, information, and career opportunities in IT. With interactive features, we enable alumni to reconnect, collaborate, and stay updated in this dynamic field. Join us in shaping a bright future for our Information Systems graduates!";

  final List<Map<String, String>> teamMembers = [
    {
      'name': 'Angga',
      'imagePath': 'assets/images/angga.jpeg',
      'instagram': 'https://instagram.com/angga_dwinnd',
      'isLeader': 'true',
    },
    {
      'name': 'Candra',
      'imagePath': 'assets/images/candra.jpeg',
      'instagram': 'https://instagram.com/Candradipasantii',
      'isLeader': 'false',
    },
    {
      'name': 'Bhathiya',
      'imagePath': 'assets/images/batok.jpeg',
      'instagram': 'https://instagram.com/bhathiya.1221',
      'isLeader': 'false',
    },
    {
      'name': 'Anggita',
      'imagePath': 'assets/images/anggita.jpeg',
      'instagram': 'https://instagram.com/anggita_cj',
      'isLeader': 'false',
    },
  ];

  // void _launchURL(String url) async {
  //   // ignore: deprecated_member_use
  //   if (await canLaunch(url)) {
  //     // ignore: deprecated_member_use
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<void> _launchURL(String url) async {
  if (!await launchUrl(Uri.parse(url))) {
    throw Exception('Could not launch $url');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alumni-Circle',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34,
              color: primaryFontColor),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: secondaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    introAboutUs,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 30.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AssetImageWidget(
                      imagePath: 'assets/images/aboutUs.png',
                      width: 500,
                      height: 259,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 15),
                    Text(
                      detailDescription,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: primaryFontColor),
                    ),
                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 30),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Development Team 🛠',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: primaryFontColor,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Leader
                        GestureDetector(
                          onTap: () {
                            _launchURL(teamMembers[0]['instagram']!);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundImage:
                                    AssetImage(teamMembers[0]['imagePath']!),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                teamMembers[0]['name']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: primaryFontColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: primaryColor,
                                ),
                                child: const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Members
                        Wrap(
                          spacing: 30.0,
                          runSpacing: 30.0,
                          alignment: WrapAlignment.center,
                          children: teamMembers.sublist(1).map((member) {
                            return GestureDetector(
                              onTap: () {
                                _launchURL(member['instagram']!);
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage(member['imagePath']!),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    member['name']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: primaryFontColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
