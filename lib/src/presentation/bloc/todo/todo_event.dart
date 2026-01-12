import 'package:equatable/equatable.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Triggered when the app starts to open the database stream
class LoadTodos extends TodoEvent {
  @override
  List<Object?> get props => [];
}

// Triggered by the "Save" button in your Add/Edit dialog
class AddTodo extends TodoEvent {
  final String task;
  final TodoCategories category;
  AddTodo({required this.task, required this.category});

  @override
  List<Object?> get props => [task, category];
}

class UpdateTodo extends TodoEvent {
  final String task;
  final int id;
  final TodoCategories category;
  final TodoCompletion? status;
  UpdateTodo({
    required this.task,
    required this.category,
    required this.id,
    this.status,
  });

  @override
  List<Object?> get props => [task, category, id, status];
}

class DeleteTodo extends TodoEvent {
  final TodoData todo;
  DeleteTodo(this.todo);

  @override
  List<Object?> get props => [todo];
}

class OnDataChanged extends TodoEvent {
  final List<TodoData> todos;
  OnDataChanged(this.todos);

  @override
  List<Object?> get props => [todos];
}

class CheckCategories extends TodoEvent {
  final TodoCategories cate;
  CheckCategories(this.cate);
  @override
  List<Object?> get props => [cate];
}

class UpdateFilter extends TodoEvent {
  final TodoCategories? selectedCategories;
  final TodoCompletion? selectedStatuses;
  final bool isClear;
  UpdateFilter({
    this.selectedCategories,
    this.selectedStatuses,
    this.isClear = false,
  });

  @override
  List<Object?> get props => [selectedCategories, selectedStatuses, isClear];
}

// SetWorkIncompleteFilter();
