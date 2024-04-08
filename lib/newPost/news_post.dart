import 'package:flutter/material.dart';
import 'package:my_app/services/data_service.dart';

class NewsPostScreen extends StatefulWidget {
  const NewsPostScreen({Key? key}) : super(key: key);

  @override
  _NewsPostScreenState createState() => _NewsPostScreenState();
}

class _NewsPostScreenState extends State<NewsPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  void _submitNews() async {
    final String title = _titleController.text;
    final String body = _bodyController.text;

    try {
      await DataService.createNews(title, body);
      // Show success message or navigate to another screen upon successful creation
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Berita berhasil diposting'),
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      // Show error message if creation fails
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal memposting berita: $e'),
        duration: Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buat Berita Baru'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Isi Berita',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitNews,
              child: Text('Post Berita'),
            ),
          ],
        ),
      ),
    );
  }
}
