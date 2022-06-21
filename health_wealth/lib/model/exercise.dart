import 'package:json_annotation/json_annotation.dart';

part 'exercise.g.dart';

@JsonSerializable()
class Exercise {
  String name;
  int sets;
  int reps;
  // List<int> days = [0, 2, 4];
  // static final week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Exercise({required this.name, required this.sets, required this.reps});

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseToJson(this);

  // void setDays(List<int> days) {
  //   this.days = days;
  // }

  // List<String> get getDays {
  //   List<String> listDays = [];
  //   for (int index in days) {
  //     listDays.add(week[index]);
  //   }
  //   return listDays;
  // }

  /// For assigning icon to Exercise.
  int get iconIndex {
    return name == 'Push ups'
        ? 0
        : name == 'Sit ups'
            ? 1
            : name == 'Pull ups'
                ? 2
                : name == 'Squats'
                    ? 3
                    : 4;
  }

  static List<Exercise> get defaultExercises {
    final List<String> names = ['Push ups', 'Sit ups', 'Pull ups', 'Squats'];
    var exercises = List.generate(
        names.length, (i) => Exercise(name: names[i], sets: 3, reps: 10));
    return exercises;
  }
}
