import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
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
    on<GetAuthBioEvent>(_authenticateWithBiometrics);
    on<CheckBioMetrixEvent>(_checkBiometrics);
    on<GetAvailableBioEvent>(_getAvailableBiometrics);
    on<GetAuthOsEvent>(_authenticate);
    on<CancelAuthBioEvent>(_cancelAuthentication);
  }
  final LocalAuthentication auth = LocalAuthentication();
  _doLogin(DoLoginEvent event, Emitter<LoginState> emit) async {
    if (event.pin == "") {
      ToastService().error("Pin is required to login");
    } else {
      emit(state.copyWith(isLoading: true));
      await Future.delayed(Duration(seconds: 2));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var pin = prefs.getString("pin") ?? 0;

      if (pin == event.pin) {
        emit(
          state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedIn),
        );
        ToastService().success("Logged in");
      } else {
        emit(state.copyWith(isLoading: false));
        ToastService().error("Pin is Incorrect");
      }
    }
  }

  _doLogout(DoLogOutEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    emit(state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedOut));
  }

  _checkLogin(CheckLoginEvent event, Emitter<LoginState> emit) async {
    if (!state.isSignup) {
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
        add(GetAuthBioEvent());
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
  }

  _signup(DoSignUpEvent event, Emitter<LoginState> emit) async {
    if (event.pin == "" || event.username == "") {
      ToastService().error("These fields are cannot be empty");
    } else if (event.pin.length < 4) {
      ToastService().error("Minimum 4 digit pin is required");
    } else {
      emit(state.copyWith(isLoading: true));
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await Future.delayed(Duration(seconds: 2));
      var random = Random();
      prefs.setInt("userid", random.nextInt(600));
      prefs.setString("userName", event.username);
      prefs.setString("pin", event.pin);

      emit(state.copyWith(isLoading: false, loginStatus: LoginStatus.loggedIn));
      ToastService().success("Signup successfully");
    }
  }

  _toggleSignup(ToggleSignupEvent event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isSignup: !state.isSignup));
  }

  _checkBiometrics(CheckBioMetrixEvent event, Emitter<LoginState> emit) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      ToastService().error(e.toString());
    }
    emit(state.copyWith(canCheckBiometrics: canCheckBiometrics));
  }

  _getAvailableBiometrics(
    GetAvailableBioEvent event,
    Emitter<LoginState> emit,
  ) async {
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      ToastService().error(e.toString());
    }
    emit(state.copyWith(availableBiometrics: availableBiometrics));
  }

  _authenticate(GetAuthOsEvent event, Emitter<LoginState> emit) async {
    bool authenticated = false;
    try {
      emit(
        state.copyWith(isAuthenticating: true, authorized: 'Authenticating'),
      );

      authenticated = await auth.authenticate(
        localizedReason: 'Let OS determine authentication method',
        persistAcrossBackgrounding: true,
      );
      emit(state.copyWith(isAuthenticating: false));
    } on LocalAuthException catch (e) {
      ToastService().error(e.toString());
      emit(
        state.copyWith(
          isAuthenticating: false,
          authorized:
              e.code != LocalAuthExceptionCode.userCanceled &&
                  e.code != LocalAuthExceptionCode.systemCanceled
              ? 'Error - ${e.code.name}${e.description != null ? ': ${e.description}' : ''}'
              : null,
        ),
      );

      return;
    } on PlatformException catch (e) {
      print(e);

      emit(
        state.copyWith(
          isAuthenticating: false,
          authorized: 'Unexpected error - ${e.message}',
        ),
      );

      return;
    }
    emit(
      state.copyWith(
        authorized: authenticated ? 'Authorized' : 'Not Authorized',
      ),
    );
  }

  _authenticateWithBiometrics(
    GetAuthBioEvent event,
    Emitter<LoginState> emit,
  ) async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      ToastService().error(e.toString());
    }
    emit(state.copyWith(canCheckBiometrics: canCheckBiometrics));
    late List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
      ToastService().error(e.toString());
    }
    emit(state.copyWith(availableBiometrics: availableBiometrics));
    bool authenticated = false;
    try {
      emit(
        state.copyWith(isAuthenticating: true, authorized: 'Authenticating'),
      );
      authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate',
        persistAcrossBackgrounding: true,
        biometricOnly: true,
      );
      emit(
        state.copyWith(isAuthenticating: false, authorized: 'Authenticating'),
      );
    } on LocalAuthException catch (e) {
      print(e);
      emit(
        state.copyWith(
          isAuthenticating: false,
          authorized:
              e.code != LocalAuthExceptionCode.userCanceled &&
                  e.code != LocalAuthExceptionCode.systemCanceled
              ? 'Error - ${e.code.name}${e.description != null ? ': ${e.description}' : ''}'
              : null,
        ),
      );
      // if (e.code == LocalAuthExceptionCode.userCanceled ||
      //     e.code == LocalAuthExceptionCode.systemCanceled) {
      //   await SystemNavigator.pop();
      //   return;
      // }
      // return;
    } on PlatformException catch (e) {
      print(e);

      emit(
        state.copyWith(
          isAuthenticating: false,
          authorized: 'Unexpected Error - ${e.message}',
        ),
      );
      await SystemNavigator.pop();
      // return;
    }

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    emit(state.copyWith(authorized: message));
  }

  _cancelAuthentication(
    CancelAuthBioEvent event,
    Emitter<LoginState> emit,
  ) async {
    await auth.stopAuthentication();
    emit(state.copyWith(isAuthenticating: false));
  }
}
