import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class DiscussionPage extends StatefulWidget {
  const DiscussionPage({Key? key}) : super(key: key);

  @override
  _DiscussionPageState createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 650,
          color: secondaryColor,
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search Forum...',
                    filled: true,
                    fillColor: thirdColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(color: primaryFontColor),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/detailforum'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        height: 80,
                        decoration: BoxDecoration(
                          color: thirdColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 52, 42, 42),
                                borderRadius: BorderRadius.circular(50),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/angga.jpeg'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Lorem Ipsum Dolor Sit",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: primaryFontColor,
                                        ),
                                      ),
                                      Icon(
                                        Icons.favorite_border,
                                        color: Colors.redAccent,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Kadek John",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: secondaryFontColor,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "100 Replies",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: primaryFontColor,
                                        ),
                                      ),
                                      Text(
                                        "2 FEB 2024",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: secondaryFontColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Tampilkan dialog form tambahan
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Add the Forum', textAlign: TextAlign.center,),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const TextField(
                      // controller: _titleController,
                      decoration: InputDecoration(labelText: 'Judul'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      // controller: _contentController,
                      decoration: const InputDecoration(labelText: 'Isi'),
                      maxLines: 4,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                    },
                    child: Text('Tambah'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
