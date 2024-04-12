import 'package:flutter/material.dart';
// import 'package:my_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
// import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  // Future<void> _launchURL(String url) async {
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: null,
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              "News | Latihan API",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/newsscreen"),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text(
              "Postingan | Latihan SQLite",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/post"),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "About US",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/aboutus"),
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text(
              "Help",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/help"),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => Navigator.pushNamed(context, "/Logout"),
          ),
          const Divider(),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
