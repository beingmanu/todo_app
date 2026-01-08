part of "login_bloc.dart";

enum LoginStatus { loggedIn, loggedOut, askingpin }

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final UserModel? userDetail;
  final bool isLoading;
  final bool isSignup;

  const LoginState({
    required this.loginStatus,
    required this.userDetail,
    required this.isLoading,
    required this.isSignup,
  });

  @override
  List<Object?> get props => [loginStatus, userDetail, isLoading, isSignup];

  const LoginState.initial()
    : this(
        loginStatus: LoginStatus.loggedOut,
        userDetail: null,
        isLoading: false,
        isSignup: false,
      );

  LoginState copyWith({
    LoginStatus? loginStatus,
    UserModel? userDetail,
    bool? isLoading,
    bool? isSignup,
  }) => LoginState(
    loginStatus: loginStatus ?? this.loginStatus,
    userDetail: userDetail ?? this.userDetail,
    isLoading: isLoading ?? this.isLoading,
    isSignup: isSignup ?? this.isSignup,
  );
}
