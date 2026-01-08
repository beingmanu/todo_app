import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

enum TodoCategories { personal, work, shopping }

extension TodoCategoriesExtention on TodoCategories {
  String get value {
    switch (this) {
      case TodoCategories.personal:
        return "Personal";
      case TodoCategories.shopping:
        return "Shopping";
      case TodoCategories.work:
        return "Work";
    }
  }
}

enum TodoCompletion { done, incomplete }

extension TotoStatusExtention on TodoCompletion {
  String get value {
    switch (this) {
      case TodoCompletion.done:
        return "Done";
      case TodoCompletion.incomplete:
        return "Incomplete";
    }
  }
}

@entity
class TodoData extends Equatable {
  @primaryKey
  final int id;
  final String text;
  final String time;
  final TodoCompletion status;
  final TodoCategories category;

  const TodoData({
    required this.id,
    required this.text,
    required this.time,
    required this.status,
    required this.category,
  });

  factory TodoData.fromMap(Map<String, dynamic> map) {
    return TodoData(
      id: map['id'],
      text: map['text'],
      time: map['time'],
      status: map['status'],
      category: map['category'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "text": text,
      "time": time,
      "status": status,
      "category": category,
    };
  }

  @override
  List<Object?> get props => [id, text, time, status, category];
}
