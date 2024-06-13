import 'package:flutter/material.dart';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  final desc = "Connect like never before, with our alumni app.";
  final detailDesc =
      "Reconnect with old friends, network with professionals, and explore new opportunities.";

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: AssetImageWidget(
              imagePath: 'assets/images/intropage.png',
              width: 411,
              height: 259,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              desc,
              style: const TextStyle(
                  fontSize: 34,
                  color: primaryFontColor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              detailDesc,
              style: const TextStyle(
                  fontSize: 14,
                  color: primaryFontColor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 28
            ),
            child: ElevatedButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/navigate');
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Atur radius sudut menjadi 10
                ),
                minimumSize: Size(double.infinity, 48),),
            child: Text(
              'get started',
              style: TextStyle(
                    fontSize: 16,
                    color: primaryFontColor,
                    fontWeight: FontWeight.bold
                  ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
