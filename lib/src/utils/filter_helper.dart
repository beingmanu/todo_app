import '../domain/model/todo_model.dart';

List<TodoData> filterTodos({
  required List<TodoData> allTodos,
  required Set<TodoCategories> selectedCategories,
  required Set<TodoCompletion> selectedStatuses,
}) {
  return allTodos.where((todo) {
    // 1. Check Categories: If none selected, allow all.
    // Otherwise, todo must be in the selected set.
    final categoryMatch =
        selectedCategories.isEmpty ||
        selectedCategories.contains(todo.category);

    // 2. Check Status: If none selected, allow all.
    // Otherwise, todo must be in the selected set.
    final statusMatch =
        selectedStatuses.isEmpty || selectedStatuses.contains(todo.status);

    // 3. Combine: Both conditions must be true
    return categoryMatch && statusMatch;
  }).toList();
}
