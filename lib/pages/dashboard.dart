import 'package:flutter/material.dart';
import 'package:alumni_circle_app/components/asset_image_widget.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'dart:async';

import 'package:alumni_circle_app/utils/menu_items.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: primaryColor,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            right: 0.0,
            top: -10.0,
            child: Opacity(
              opacity: 0.2,
              child: Center(
                child: AssetImageWidget(
                  imagePath: 'assets/images/intropage.png',
                  width: 500,
                  height: 259,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     Navigator.pop(context);
                        //   },
                        //   child: const Icon(
                        //     Icons.menu,
                        //     color: primaryFontColor,
                        //   ),
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  AssetImage('assets/images/angga.jpeg'),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            TimeNow()
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 174.0,
                    ),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      color: secondaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24.0,
                      horizontal: 24.0,
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: thirdColor,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15.0,
                          ),
                          child: const Column(
                            children: [
                              Text(
                                "Bio",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Name"),
                                  Text("I Kadek John Deo")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Email"),
                                  Text("kadekjohn@gmail.com")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Address"),
                                  Text("Br Dinas Newyork City")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Graduate Date"),
                                  Text("1990-02-30")
                                ],
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [Text("Batch"), Text("1st")],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: 250,
                          padding: const EdgeInsets.all(10.0),
                            child: GridView.count(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 15.0,
                              padding: const EdgeInsets.all(10.0),
                              children: getMenuItems(context).map((item) {
                                return GestureDetector(
                                  onTap: item.onPressed,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(
                                              0.5), // Warna bayangan
                                          spreadRadius:
                                              2, // Jarak bayangan dari objek
                                          blurRadius:
                                              5, // Besarnya "blur" pada bayangan
                                          offset: Offset(0,
                                              3), // Posisi bayangan relatif terhadap objek
                                        ),
                                      ],
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AssetImageWidget(
                                          imagePath: item.img,
                                          width: 64,
                                          height: 64,
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                            height:
                                                8), // Berikan jarak antara gambar dan teks
                                        Text(
                                          item.title,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class TimeNow extends StatefulWidget {
  const TimeNow({super.key});

  @override
  State<TimeNow> createState() => _TimeNowState();
}

class _TimeNowState extends State<TimeNow> {
  String _timeOfDay = '';

  @override
  void initState() {
    super.initState();
    _updateTimeOfDay();
    Timer.periodic(Duration(minutes: 1), (timer) {
      _updateTimeOfDay();
    });
  }

  void _updateTimeOfDay() {
    DateTime now = DateTime.now();
    if (now.hour >= 0 && now.hour < 12) {
      setState(() {
        _timeOfDay = 'Morning';
      });
    } else if (now.hour >= 12 && now.hour < 18) {
      setState(() {
        _timeOfDay = 'Afternoon';
      });
    } else {
      setState(() {
        _timeOfDay = 'Evening';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "Good $_timeOfDay\n",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryFontColor,
                  fontWeight: FontWeight.w500,
                ),
          ),
          TextSpan(
            text: "John Deo!",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryFontColor,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
      ),
    );
  }
}
