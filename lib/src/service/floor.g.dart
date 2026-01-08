// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floor.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `TodoData` (`id` INTEGER NOT NULL, `text` TEXT NOT NULL, `time` TEXT NOT NULL, `status` INTEGER NOT NULL, `category` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _todoDataInsertionAdapter = InsertionAdapter(
            database,
            'TodoData',
            (TodoData item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'time': item.time,
                  'status': item.status.index,
                  'category': item.category.index
                },
            changeListener),
        _todoDataUpdateAdapter = UpdateAdapter(
            database,
            'TodoData',
            ['id'],
            (TodoData item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'time': item.time,
                  'status': item.status.index,
                  'category': item.category.index
                },
            changeListener),
        _todoDataDeletionAdapter = DeletionAdapter(
            database,
            'TodoData',
            ['id'],
            (TodoData item) => <String, Object?>{
                  'id': item.id,
                  'text': item.text,
                  'time': item.time,
                  'status': item.status.index,
                  'category': item.category.index
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TodoData> _todoDataInsertionAdapter;

  final UpdateAdapter<TodoData> _todoDataUpdateAdapter;

  final DeletionAdapter<TodoData> _todoDataDeletionAdapter;

  @override
  Stream<List<TodoData>> watchAllTodos() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM TodoData ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => TodoData(
            id: row['id'] as int,
            text: row['text'] as String,
            time: row['time'] as String,
            status: TodoCompletion.values[row['status'] as int],
            category: TodoCategories.values[row['category'] as int]),
        queryableName: 'TodoData',
        isView: false);
  }

  @override
  Future<List<TodoData>> findAllTodos() async {
    return _queryAdapter.queryList('SELECT * FROM TodoData',
        mapper: (Map<String, Object?> row) => TodoData(
            id: row['id'] as int,
            text: row['text'] as String,
            time: row['time'] as String,
            status: TodoCompletion.values[row['status'] as int],
            category: TodoCategories.values[row['category'] as int]));
  }

  @override
  Stream<List<TodoData>> watchTodosByCategory(String category) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM Todo WHERE category = ?1',
        mapper: (Map<String, Object?> row) => TodoData(
            id: row['id'] as int,
            text: row['text'] as String,
            time: row['time'] as String,
            status: TodoCompletion.values[row['status'] as int],
            category: TodoCategories.values[row['category'] as int]),
        arguments: [category],
        queryableName: 'Todo',
        isView: false);
  }

  @override
  Stream<int?> countCompletedTodos() {
    return _queryAdapter.queryStream(
        'SELECT COUNT(*) FROM Todo WHERE isCompleted = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        queryableName: 'Todo',
        isView: false);
  }

  @override
  Future<void> insertTodo(TodoData todo) async {
    await _todoDataInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(TodoData todo) async {
    await _todoDataUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodo(TodoData todo) async {
    await _todoDataDeletionAdapter.delete(todo);
  }
}
