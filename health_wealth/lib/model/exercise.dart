import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  String name;
  int sets;
  int reps;
  int iconIndex = -1;

  Exercise({required this.name, required this.sets, required this.reps});

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  /// For assigning icon to default Exercise.
  int get defaultIconIndex {
    return name == 'Push ups'
        ? 0
        : name == 'Sit ups'
            ? 1
            : name == 'Pull ups'
                ? 2
                : name == 'Squats'
                    ? 3
                    : 8;
  }

  static List<Exercise> get defaultExercises {
    final List<String> names = ['Push ups', 'Sit ups', 'Pull ups', 'Squats'];
    var exercises = List.generate(
        names.length, (i) => Exercise(name: names[i], sets: 3, reps: 10));
    return exercises;
  }
}
