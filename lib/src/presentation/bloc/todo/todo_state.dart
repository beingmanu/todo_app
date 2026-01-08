import 'package:equatable/equatable.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';

class TodoState extends Equatable {
  final List<TodoData> todos;
  final bool isLoading;

  const TodoState({this.todos = const [], this.isLoading = false});

  int get total => todos.length;
  int get completed =>
      todos.where((t) => t.status == TodoCompletion.done).length;
  double get completionRate => total == 0 ? 0.0 : (completed / total);

  TodoState copyWith({List<TodoData>? todos, bool? isLoading}) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [todos, isLoading];
}
