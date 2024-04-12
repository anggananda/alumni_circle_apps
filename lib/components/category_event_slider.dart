import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/category_event.dart';
import 'package:alumni_circle_app/utils/constants.dart'; // Mengimpor file yang berisi definisi kelas CategoryEvent dan fungsi getCategoryEvents

class CategorySlider extends StatelessWidget {
  const CategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil list dari CategoryEvent
    List<CategoryEvent> categoryEvents = getCategoryEvents(context);

    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          CategoryEvent categoryEvent = categoryEvents[index];

          return GestureDetector(
            onTap: categoryEvent.onPressed,
            child: Container(
              width: 200, // Lebar container
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0), // Border radius
                image: DecorationImage(
                  // image: AssetImage(categoryEvent.img),
                  image: NetworkImage(categoryEvent.img),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Warna bayangan
                    spreadRadius: 2, // Jarak bayangan dari objek
                    blurRadius: 5, // Besarnya "blur" pada bayangan
                    offset:
                        Offset(0, 3), // Posisi bayangan relatif terhadap objek
                  ),
                ],
              ),
              padding: const EdgeInsets.all(12.0), // Padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    categoryEvent.title, // Teks title dari objek CategoryEvent
                    style: const TextStyle(
                        color: secondaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    textAlign: TextAlign.center, // Warna teks
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          // Separator antara event
          return const SizedBox(
            width: 15.0,
          );
        },
        itemCount: categoryEvents.length, // Jumlah event
      ),
    );
  }
}
