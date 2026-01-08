part of 'login_bloc.dart';

class LoginEvent extends Equatable {
  const LoginEvent();
  @override
  List<Object?> get props => [];
}

class DoLoginEvent extends LoginEvent {
  final String username;
  final int pin;
  const DoLoginEvent({required this.pin, required this.username});
  @override
  List<Object?> get props => [username, pin];
}

class DoSignUpEvent extends LoginEvent {
  final String username;
  final int pin;
  const DoSignUpEvent({required this.pin, required this.username});
  @override
  List<Object?> get props => [username, pin];
}

class DoLogOutEvent extends LoginEvent {
  const DoLogOutEvent();
  @override
  List<Object?> get props => [];
}

class CheckLoginEvent extends LoginEvent {
  const CheckLoginEvent();
  @override
  List<Object?> get props => [];
}

class ToggleSignupEvent extends LoginEvent {
  const ToggleSignupEvent();
  @override
  List<Object?> get props => [];
}
