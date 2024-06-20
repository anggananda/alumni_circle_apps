class Categories{
  final int idCategory;
  final String nameCategory;
  final String description;
  final String image;

  Categories({
    required this.idCategory, required this.nameCategory, required this.description, required this.image
  });

  factory Categories.fromJson(Map<String, dynamic> json) => Categories(
    idCategory: json['id_kategori'] as int,
    nameCategory: json['kategori'] as String,
    description: json['deskripsi'] as String,
    image: json['gambar'] as String,
  );
}