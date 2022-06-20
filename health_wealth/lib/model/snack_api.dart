import 'package:json_annotation/json_annotation.dart';

part 'snack_api.g.dart';

@JsonSerializable(createToJson: false)
class SnackAPI {
  final String name;
  final double calories;

  SnackAPI({
    required this.name,
    required this.calories,
  });

  factory SnackAPI.fromJson(Map<String, dynamic> json) =>
      _$SnackAPIFromJson(json);

  // static List<SnackAPI> listOfSnackAPIsFromJson(json) => (json as List)
  //     .map((data) => SnackAPI.fromJson(data as Map<String, dynamic>))
  //     .toList();

  @override
  String toString() {
    return 'Snack {name: $name, calories: $calories}';
  }
}
