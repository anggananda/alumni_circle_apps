import 'package:flutter/material.dart';
import 'package:my_app/components/asset_image_widget.dart';
import 'package:my_app/utils/constants.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  final introAboutUs =
      "Elevate your alumni network with our dedicated SI alumni app. Reconnect, collaborate, and succeed effortlessly.";
  final detailDescription =
      "Welcome to our Alumni App for the Information Systems program! Designed exclusively for alumni of our university's Information Systems program, our platform aims to enhance the alumni network while facilitating the exchange of experiences, information, and career opportunities in IT. With interactive features, we enable alumni to reconnect, collaborate, and stay updated in this dynamic field. Join us in shaping a bright future for our Information Systems graduates!";

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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      )),
                  child: Center(
                    child: Text(
                      introAboutUs,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
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
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        detailDescription,
                        textAlign: TextAlign.justify,
                        style: const TextStyle(color: primaryFontColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
