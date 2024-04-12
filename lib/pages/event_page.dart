import 'package:flutter/material.dart';
import 'package:alumni_circle_app/components/category_event_slider.dart';
import 'package:alumni_circle_app/components/event_slider.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: secondaryColor,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 120,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  color: primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 30.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Event...',
                    filled: true,
                    fillColor: secondaryColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: primaryFontColor),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Category",
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 20),
              const CategorySlider(),
              const SizedBox(height: 10.0),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "See All the Events",
                      style: TextStyle(
                        color: primaryFontColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              const EventSlider()
            ],
          ),
        ),
      ),
    );
  }
}
