import 'package:equatable/equatable.dart';
import 'package:todo_withbloc/src/domain/model/todo_model.dart';

import '../../../utils/filter_helper.dart';

class TodoState extends Equatable {
  final List<TodoData> todos;
  final bool isLoading;
  final TodoCategories? category;
  final Set<TodoCategories> selectedCategories;
  final Set<TodoCompletion> selectedStatuses;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.category = TodoCategories.personal,
    this.selectedCategories = const {},
    this.selectedStatuses = const {},
  });

  int get total => todos.length;
  List<TodoData> get filteredTodos => filterTodos(
    allTodos: todos,
    selectedCategories: selectedCategories,
    selectedStatuses: selectedStatuses,
  );

  TodoState copyWith({
    List<TodoData>? todos,
    bool? isLoading,
    TodoCategories? category,
    Set<TodoCategories>? selectedCategories,
    Set<TodoCompletion>? selectedStatuses,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      category: category ?? this.category,
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedStatuses: selectedStatuses ?? this.selectedStatuses,
    );
  }

  @override
  List<Object?> get props => [
    todos,
    isLoading,
    category,
    selectedCategories,
    selectedStatuses,
  ];
}
