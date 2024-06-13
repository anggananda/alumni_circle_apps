class Total{
  final int total;

  Total({required this.total});

  factory Total.fromJson(Map<String, dynamic> json) => Total(
    total: json['Total'] as int,
  );
}