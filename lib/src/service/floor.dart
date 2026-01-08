import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqlite_api.dart' as sqflite;
import 'package:todo_withbloc/src/domain/model/todo_model.dart';
part 'floor.g.dart';

@Database(version: 1, entities: [TodoData])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao; // Define the getter here
}

@dao
abstract class TodoDao {
  // 1. READ: Get all todos as a Stream
  // This is vital for Bloc because the UI will auto-update when data changes
  @Query('SELECT * FROM TodoData ORDER BY id DESC')
  Stream<List<TodoData>> watchAllTodos();

  // 2. READ: One-time fetch (Future)
  @Query('SELECT * FROM TodoData')
  Future<List<TodoData>> findAllTodos();

  // 3. CREATE: Insert a new Todo
  @insert
  Future<void> insertTodo(TodoData todo);

  // 4. UPDATE: Edit an existing Todo
  // Floor matches the 'id' of the object to find the correct row
  @update
  Future<void> updateTodo(TodoData todo);

  // 5. DELETE: Remove a Todo
  @delete
  Future<void> deleteTodo(TodoData todo);

  // 6. FILTER: Get todos by category
  @Query('SELECT * FROM Todo WHERE category = :category')
  Stream<List<TodoData>> watchTodosByCategory(String category);

  // 7. STATISTICS: Count completed vs total
  @Query('SELECT COUNT(*) FROM Todo WHERE isCompleted = 1')
  Stream<int?> countCompletedTodos();
}
