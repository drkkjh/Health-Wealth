class Snack {
  final String name;
  final num calories;

  Snack({required this.name, required this.calories});

  Map<String, dynamic> toJson() => {'name': name, 'calories': calories};
}
