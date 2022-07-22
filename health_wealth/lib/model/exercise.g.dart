// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      name: json['name'] as String,
      sets: json['sets'] as int,
      reps: json['reps'] as int,
    )..iconIndex = json['iconIndex'] as int;

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'name': instance.name,
      'sets': instance.sets,
      'reps': instance.reps,
      'iconIndex': instance.iconIndex,
    };
