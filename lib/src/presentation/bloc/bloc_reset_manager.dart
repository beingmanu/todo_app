import 'dart:async';

class BlocResetManager {
  static final _instance = BlocResetManager._internal();
  factory BlocResetManager() => _instance;
  BlocResetManager._internal();

  final _resetController = StreamController<void>.broadcast();
  Stream<void> get resetStream => _resetController.stream;

  void resetAllBlocs() {
    _resetController.add(null);
  }

  void dispose() {
    _resetController.close();
  }
}
