class Datas{
  final int idDatas;
  final String name;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Datas({
    required this.idDatas,
    required this.name,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
    idDatas: json['id_datas'] as int,
    name: json['name'] as String,
    imageUrl: json['image_url'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] != null 
    ? DateTime.parse(json['deleted_at'] as String)
    : null
  );
}