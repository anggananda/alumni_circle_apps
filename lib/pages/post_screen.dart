import 'package:flutter/material.dart';
import 'package:my_app/helpers/dbhelper.dart';
import 'package:my_app/models/posts.dart';
import 'package:my_app/pages/inputpostingan.dart';
import 'package:my_app/utils/constants.dart';

class PostPage extends StatefulWidget {
  const PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostinganPageState();
}

class _PostinganPageState extends State<PostPage> {
  final dbHelper = DatabaseHelper();

  @override
  void dispose() {
    dbHelper.close();
    super.dispose();
  }

  void _addPost(String title, String content) async {
    Post newPost = Post(
      title: title,
      content: content,
      date: DateTime.now(),
    );
    await dbHelper.addPost(newPost);
    setState(() {});
  }

  void _deletePost(int id) async {
    await dbHelper.deletePost(id);
    setState(() {});
  }

  void _updatePost(Post post) {
    TextEditingController _titleController = TextEditingController(text: post.title);
    TextEditingController _contentController = TextEditingController(text: post.content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Postingan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  onChanged: (value) {
                    post.title = value;
                  },
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _contentController,
                  onChanged: (value) {
                    post.content = value;
                  },
                  decoration: InputDecoration(labelText: 'Content'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: primaryFontColor),),
            ),
            ElevatedButton(
              onPressed: () async {
                // Panggil dbHelper untuk memperbarui postingan di database
                await dbHelper.updatePost(post);
                // Perbarui tampilan dengan setState agar perubahan terlihat
                setState(() {});
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // background color
                onPrimary: primaryFontColor, // text color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          elevation: 8.0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alumni Posts SQLite CRUD'),
        backgroundColor: primaryColor,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(color: secondaryColor),
        child: FutureBuilder<List<Post>>(
          future: dbHelper.getPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final post = snapshot.data![index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                  child: Container(
                  decoration: BoxDecoration(
                    color: thirdColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Warna bayangan
                        spreadRadius: 2, // Jarak bayangan dari objek
                        blurRadius: 5, // Besarnya "blur" pada bayangan
                        offset: Offset(
                            0, 3), // Posisi bayangan relatif terhadap objek
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              post.title,
                              style: const TextStyle(
                                color: primaryFontColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            subtitle: Text(
                              post.content,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: primaryFontColor, fontSize: 12),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${post.date}', style: TextStyle(
                                fontSize: 12,
                                color: secondaryFontColor
                              ),),
                              Row(
                                children: [
                                  IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deletePost(post.id!);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _updatePost(post);
                                },
                              ),
                                ],
                              )
                              
                            ],
                          )
                        ],
                      )),
                    ],
                  ),
                ),
                ); 
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddPostForm(
                onSubmit: (title, content) => _addPost(title, content),
                dbHelper: dbHelper,
              );
            },
          );
        },
        tooltip: 'Add Post',
        child: Icon(Icons.add),
      ),
    );
  }
}
