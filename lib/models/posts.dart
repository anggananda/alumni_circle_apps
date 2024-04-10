class Post {
  int? id;
  String title;
  String content;
  DateTime date;

  Post({this.id, required this.title, required this.content, required this.date});

  // Konversi Post menjadi Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
    };
  }

  // Konversi Map menjadi Post
  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      date: DateTime.parse(map['date']),
    );
  }
}
