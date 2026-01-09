import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_withbloc/src/utils/toast_util.dart';

import '../../../domain/model/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<DoLoginEvent>(_doLogin);
    on<DoLogOutEvent>(_doLogout);
    on<CheckLoginEvent>(_checkLogin);
    on<DoSignUpEvent>(_signup);
    on<ToggleSignupEvent>(_toggleSignup);
  }

  _doLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));
    await Future.delayed(Duration(seconds: 2));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var pin = prefs.getInt("pin") ?? 0;

    if (pin == event.pin) {
      emit(state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedIn));
      ToastService().success("Logged in");
    } else {
      emit(state.copyWith(isLoading: false));
      ToastService().error("Pin is Incorrect");
    }
  }

  _doLogout(DoLogOutEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedOut));
  }

  _checkLogin(CheckLoginEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString("userName");

    if (username != null) {
      int? userid = prefs.getInt("userid") ?? 0;

      var newUser = UserModel(userName: username, userId: userid);
      emit(
        state.copyWith(
          userDetail: newUser,
          loginStatus: LoginStatus.askingpin,
          isLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          loginStatus: LoginStatus.loggedOut,
          isLoading: false,
          isSignup: true,
        ),
      );
    }
  }

  _signup(DoSignUpEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 2));
    var random = Random();
    prefs.setInt("userid", random.nextInt(600));
    prefs.setString("userName", event.username);
    prefs.setInt("pin", event.pin);
    emit(state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedIn));
    ToastService().success("Signup successfully");
  }

  _toggleSignup(ToggleSignupEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isSignup: !state.isSignup));
  }
}
