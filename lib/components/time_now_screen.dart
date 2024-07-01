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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTimeOfDay();
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateTimeOfDay();
    });
  }

  void _updateTimeOfDay() {
    DateTime now = DateTime.now();
    if (!mounted) return; // Pastikan widget masih aktif sebelum memanggil setState

    setState(() {
      if (now.hour >= 0 && now.hour < 12) {
        _timeOfDay = 'Morning';
      } else if (now.hour >= 12 && now.hour < 18) {
        _timeOfDay = 'Afternoon';
      } else {
        _timeOfDay = 'Evening';
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Batalkan timer
    super.dispose();
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
