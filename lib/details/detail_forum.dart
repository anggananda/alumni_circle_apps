import 'package:flutter/material.dart';
import 'package:alumni_circle_app/utils/constants.dart';

class DetailForum extends StatefulWidget {
  const DetailForum({super.key});

  @override
  State<DetailForum> createState() => _DetailForumState();
}

class _DetailForumState extends State<DetailForum> {
  int _countLike = 0;
  int _countDislike = 0;

  void _incrementLike() {
    setState(() {
      _countLike++;
    });
  }

  void _incrementDislike() {
    setState(() {
      _countDislike++;
    });
  }

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
      body: Column(
        children: [
          Expanded(
              child: Container(
            color: secondaryColor,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    color: thirdColor,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/images/angga.jpeg'),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "Kadek John",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "kadekjohn@gmail.com",
                                      style:
                                          TextStyle(color: secondaryFontColor),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 350,
                          child: const Text(
                            "Lorem Ipsum SItSIt",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          child: const Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(color: primaryFontColor),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Row(
                              children: [
                                Text(
                                  "12.00 PM",
                                  style: TextStyle(color: secondaryFontColor),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Jan 01, 2024",
                                  style: TextStyle(color: secondaryFontColor),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: _incrementLike,
                                      icon: Icon(
                                        Icons.thumb_up,
                                        size: 22,
                                      ),
                                    ),
                                    Text("$_countLike")
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: _incrementDislike,
                                        icon: Icon(
                                          Icons.thumb_down,
                                          size: 22,
                                        )),
                                    Text("$_countDislike")
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 5,
                        ),
                        const SizedBox(
                          width: 350,
                          child: Text(
                            "Replies",
                            style: TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          // color: Colors.red,
                          // height: 50,
                          child: Column(
                            children: [
                              Container(
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/angga.jpeg'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "Kadek John",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "kadekjohn@gmail.com",
                                            style: TextStyle(
                                                color: secondaryFontColor),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          // color: Colors.red,
                          // height: 50,
                          child: Column(
                            children: [
                              Container(
                                child: const Row(
                                  children: [
                                    SizedBox(
                                      height: 50,
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(
                                            'assets/images/angga.jpeg'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "Kadek John",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            "kadekjohn@gmail.com",
                                            style: TextStyle(
                                                color: secondaryFontColor),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.', textAlign: TextAlign.justify, style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          )),

          // !Inputan Reply
          Container(
            padding: const EdgeInsets.all(8.0),
            color: thirdColor,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type your comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
