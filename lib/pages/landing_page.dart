import 'package:flutter/material.dart';
import 'package:my_app/components/asset_image_widget.dart';
import 'package:my_app/utils/constants.dart';

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
          SizedBox(
            width: 360,
            height: 62,
            child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/navigate'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: const Text(
                  "get started",
                  style: TextStyle(fontSize: 16, color: primaryFontColor, ),
                )),
          )
        ],
      ),
    );
  }
}
