import 'package:alumni_circle_app/cubit/profile/cubit/profile_cubit.dart';
import 'package:alumni_circle_app/services/data_service.dart';
import 'package:alumni_circle_app/utils/dialog_helpers.dart';
import 'package:alumni_circle_app/utils/secure_storage_util.dart';
import 'package:flutter/material.dart';
// import 'package:my_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  Future<void> doLogout(context) async {
    debugPrint("need logout");
    final response = await DataService.logoutData();
    if (response.statusCode == 200) {
      debugPrint('Logout berhasi ${response.statusCode}');
      await SecureStorageUtil.storage.delete(key: tokenStoreName);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Successfully'))
      );
      Navigator.pushReplacementNamed(context, "/login");
    } else {
      debugPrint('${response.statusCode}');
    }
  }

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
            leading: const Icon(Icons.face_unlock_sharp, color: colors2,),
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
          ExpansionTile(
            leading: Icon(Icons.headset_mic, color: colors2,),
            title: Text(
              'Support',
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Icon(Icons.help, color: colors2,),
                  title: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.roles == 'admin') {
                        return Text('Question Box');
                      } else {
                        return Text('Question');
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/help');
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: const Icon(Icons.feedback, color: colors2,),
                  title: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state.roles == 'admin') {
                        return Text('Feedback Hub');
                      } else {
                        return Text('Feedback');
                      }
                    },
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/feedback');
                  },
                ),
              )
            ],
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: colors2,),
            title: const Text(
              "Logout",
              style: TextStyle(
                color: primaryFontColor,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () => {
              showLogoutDialog(
              context: context,
              onLogout: () => doLogout(context),
            )
            },
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
