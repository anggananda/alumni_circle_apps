import 'dart:async';

import 'package:alumni_circle_app/dto/alumni.dart';
import 'package:alumni_circle_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TimeNow extends StatefulWidget {
  final Alumni? alumni;

  const TimeNow({Key? key, this.alumni}) : super(key: key);

  @override
  State<TimeNow> createState() => _TimeNowState();
}

class _TimeNowState extends State<TimeNow> {
  String _timeOfDay = '';

  @override
  void initState() {
    super.initState();
    _updateTimeOfDay();
    Timer.periodic(const Duration(minutes: 1), (timer) {
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
            text: widget.alumni?.username, // Akses post melalui widget
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: primaryFontColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}
