class Issues {
  final int idCustomerService;
  final String nim;
  final String titleIssues;
  final String descriptionIssues;
  final int rating;
  final String? imageUrl;
  final dynamic divisionTarget;
  final dynamic priority;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Issues({
    required this.idCustomerService,
    required this.nim,
    required this.titleIssues,
    required this.descriptionIssues,
    required this.rating,
    this.imageUrl,
    required this.divisionTarget,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Issues.fromJson(Map<String, dynamic> json) => Issues(
      idCustomerService: json["id_customer_service"] as int,
      nim: json["nim"] as String,
      titleIssues: json["title_issues"] as String,
      descriptionIssues: json["description_issues"] as String,
      rating: json["rating"] as int,
      imageUrl: json["image_url"] as String?,
      divisionTarget: json["division_target"],
      priority: json["priority"],
      createdAt: DateTime.parse(json["created_at"] as String),
      updatedAt: DateTime.parse(json["updated_at"] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null);
}
