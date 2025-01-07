import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final String? description;
  final bool finished;

  TaskModel({
    required this.id,
    required this.title,
    this.description,
    required this.finished,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? finished,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      finished: finished ?? this.finished,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'finished': finished,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      finished: map['finished'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaskModel &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.finished == finished;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        finished.hashCode;
  }
}
