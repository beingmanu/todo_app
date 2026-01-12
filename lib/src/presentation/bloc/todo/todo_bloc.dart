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
      try {
        final newTodo = TodoData(
          id: Random().nextInt(99999),
          text: event.task,
          category: state.category!,
          status: TodoCompletion.incomplete,
          time: DateTime.now().toIso8601String(),
        );
        await dao.insertTodo(newTodo);
        ToastService().success("Task Saved!");
      } catch (e) {
        ToastService().error(e.toString());
      }
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
        ToastService().success("Task updated!");
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
    on<UpdateFilter>((event, emit) {
      if (event.isClear) {
        emit(state.copyWith(selectedCategories: {}, selectedStatuses: {}));
      } else {
        final updatedCategories = Set<TodoCategories>.from(
          state.selectedCategories,
        );
        final updatedStatuses = Set<TodoCompletion>.from(
          state.selectedStatuses,
        );

        // 2. Handle Category Toggle
        if (event.selectedCategories != null) {
          if (updatedCategories.contains(event.selectedCategories)) {
            updatedCategories.remove(event.selectedCategories);
          } else {
            updatedCategories.add(event.selectedCategories!);
          }
        }

        // 3. Handle Status Toggle
        if (event.selectedStatuses != null) {
          if (updatedStatuses.contains(event.selectedStatuses)) {
            updatedStatuses.remove(event.selectedStatuses);
          } else {
            updatedStatuses.add(event.selectedStatuses!);
          }
        }

        // 4. Emit the new state with the new Set instances
        emit(
          state.copyWith(
            selectedCategories: updatedCategories,
            selectedStatuses: updatedStatuses,
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
