import 'package:flutter/material.dart';
import 'package:my_app/utils/constants.dart';

class CategoryAnniversery extends StatelessWidget {
  const CategoryAnniversery({super.key});

  static const List<String> imageUrls = [
    'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  final String description =
      "The category of educational events on campus encompasses various activities such as seminars, workshops, short courses, panel discussions, leadership training, education fairs, guest lectures, and academic competitions. These events aim to provide participants with new knowledge, skills, and insights beyond formal academic settings, as well as to enhance their experience and understanding of specific topics.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     "Educations",
        //     style: TextStyle(color: primaryFontColor),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: primaryColor,
        // ),
        body: SingleChildScrollView(
      child: Container(
        color: secondaryColor,
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: const NetworkImage(
                      'https://images.unsplash.com/photo-1551972873-b7e8754e8e26?q=80&w=1527&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 70,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor,
                            ),
                            child: const Icon(Icons.arrow_back),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "🌟 Overview",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryFontColor),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    "Details",
                    style: TextStyle(color: primaryFontColor),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(color: primaryFontColor),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const Row(
              children: [
                SizedBox(
                  width: 20.0,
                ),
                Text(
                  "Preview",
                  style: TextStyle(
                      color: primaryFontColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 150,
              padding: EdgeInsets.all(10),
              child: ListView.separated(
                itemCount: imageUrls.length,
                physics: const BouncingScrollPhysics(),
                // padding: const EdgeInsets.symmetric(horizontal: 24.0),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (BuildContext context, int index) {
                  // Separator antara event
                  return const SizedBox(
                    width: 15.0,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    width: 150, // Atur lebar container sesuai kebutuhan
                    decoration: BoxDecoration(
                        color: Colors.blue, // Ubah warna sesuai kebutuhan
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: NetworkImage(imageUrls[index]),
                            fit: BoxFit.cover)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
