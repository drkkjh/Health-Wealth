class Exercise {
  String name;
  int sets;
  int reps;
  // List<int> days = [0, 2, 4];
  // static final week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  Exercise({required this.name, required this.sets, required this.reps});

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

  Map<String, dynamic> toJson() => {'name': name, 'sets': sets, 'reps': reps};
}
