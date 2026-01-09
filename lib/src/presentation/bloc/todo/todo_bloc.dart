import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';
import 'package:todo_withbloc/src/utils/toast_util.dart';

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
        category: state.category!,
        status: TodoCompletion.incomplete,
        time: DateTime.now().toIso8601String(),
      );
      await dao.insertTodo(newTodo);
    });

    // 3. Update Todo (Used for editing text OR toggling done)
    on<UpdateTodo>((event, emit) async {
      try {
        final newTodo = TodoData(
          id: event.id,
          text: event.task,
          category: state.category!,
          status: event.status ?? TodoCompletion.incomplete,
          time: DateTime.now().toIso8601String(),
        );
        await dao.updateTodo(newTodo);
      } catch (e) {
        ToastService().error(e.toString());
      }
    });

    // 4. Delete Todo
    on<DeleteTodo>((event, emit) async {
      await dao.deleteTodo(event.todo);
    });

    on<CheckCategories>((event, emit) {
      emit(state.copyWith(category: event.cate));
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
