import 'package:flutter/material.dart';
import 'package:my_app/dto/news.dart';
import 'package:my_app/services/data_service.dart';
import 'package:my_app/utils/constants.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  Future<List<News>>? _news;

  @override
  void initState() {
    super.initState();
    _news = DataService.fetchNews();
  }

  void _deleteNews(String id) async {
  bool confirmDelete = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text("Apakah Anda yakin ingin menghapus data?"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Setelah tombol "OK" ditekan, nilai dialog adalah true
            },
            child: const Text('Ya'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Setelah tombol "Batal" ditekan, nilai dialog adalah false
            },
            child: const Text('Batal'),
          ),
        ],
      );
    },
  );

  if (confirmDelete == null || !confirmDelete) {
    return;
  }

  try {
    await DataService.deleteNews(id);
    List<News> updatedNews = await DataService.fetchNews();
    setState(() {
      _news = Future.value(updatedNews);
    });
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informasi'),
          content: const Text("Berhasil menghapus data"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  } catch (error) {
    print('Failed to delete news: $error');
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to delete news: $error'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data News'),
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: Center(
        child: Container(
        decoration: const BoxDecoration(color: secondaryColor),
        child: FutureBuilder<List<News>>(
          future: _news,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final post = snapshot.data![index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: thirdColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), // Warna bayangan
                            spreadRadius: 2, // Jarak bayangan dari objek
                            blurRadius: 5, // Besarnya "blur" pada bayangan
                            offset: Offset(
                                0, 3), // Posisi bayangan relatif terhadap objek
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(post.photo),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                          ),
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
                                  post.body,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: secondaryFontColor,
                                    fontSize: 12
                                  ),
                                ),
                                // trailing: TextButton(
                                //   onPressed: () => _deleteNews(post.id),
                                //   child: Icon(Icons.delete),
                                // ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => _deleteNews(post.id),
                                    child: Icon(Icons.delete, color: primaryFontColor,),
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
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // Show a loading indicator while waiting for data
            return const CircularProgressIndicator();
          },
        ),
      ),
      ) 
    );
  }
}
