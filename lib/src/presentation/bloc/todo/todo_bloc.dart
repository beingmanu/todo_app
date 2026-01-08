import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';

import '../../../service/floor.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoDao dao;
  StreamSubscription? _subscription;

  TodoBloc(this.dao) : super(TodoState(isLoading: true)) {
    // 1. Initial Load & Stream Setup
    on<LoadTodos>((event, emit) {
      _subscription?.cancel();
      _subscription = dao.watchAllTodos().listen((todos) {
        add(OnDataChanged(todos));
      });
    });

    on<OnDataChanged>((event, emit) {
      emit(state.copyWith(todos: event.todos, isLoading: false));
    });

    // 2. Add Todo
    on<AddTodo>((event, emit) async {
      final newTodo = TodoData(
        id: Random().nextInt(99999),
        text: event.task,
        category: event.category,
        status: TodoCompletion.incomplete,
        time: DateTime.now().toIso8601String(),
      );
      await dao.insertTodo(newTodo);
    });

    // 3. Update Todo (Used for editing text OR toggling done)
    on<UpdateTodo>((event, emit) async {
      await dao.updateTodo(event.todo);
    });

    // 4. Delete Todo
    on<DeleteTodo>((event, emit) async {
      await dao.deleteTodo(event.todo);
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
