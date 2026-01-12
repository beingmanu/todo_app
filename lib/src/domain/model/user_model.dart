import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int userId;
  final String userName;

  const UserModel({required this.userName, required this.userId});

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    userName: map['username'],

    userId: map['userid'],
    // todos: map['todos'] != null
    //     ? List<TodoData>.from(
    //         (map['todos'] as List).map((e) => TodoData.fromMap(e)),
    //       )
    //     : null,
  );

  Map<String, dynamic> toMap() => {
    "username": userName,
    "userid": userId,
    // if (todos != null) "todos": todos!.map((e) => e.toMap()).toList(),
  };

  @override
  List<Object?> get props => [userId, userName];
}
