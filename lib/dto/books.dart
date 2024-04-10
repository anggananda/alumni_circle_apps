class Books {
  late int? id;
  late String title;
  Books(this.id, this.title);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
    };
    return map;
  }

  Books.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
  }
}