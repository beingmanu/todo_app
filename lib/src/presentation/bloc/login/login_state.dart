part of "login_bloc.dart";

enum LoginStatus { loggedIn, loggedOut, askingpin }

enum SupportState { unknown, supported, unsupported }

class LoginState extends Equatable {
  final LoginStatus loginStatus;
  final UserModel? userDetail;
  final bool isLoading;
  final bool isSignup;

  final SupportState supportState;
  final bool? canCheckBiometrics;
  final List<BiometricType>? availableBiometrics;
  final String authorized;
  final bool isAuthenticating;

  const LoginState({
    required this.loginStatus,
    required this.userDetail,
    required this.isLoading,
    required this.isSignup,
    required this.supportState,
    this.canCheckBiometrics,
    this.availableBiometrics,
    required this.authorized,
    required this.isAuthenticating,
  });

  @override
  List<Object?> get props => [
    loginStatus,
    userDetail,
    isLoading,
    isSignup,
    supportState,
    canCheckBiometrics,
    availableBiometrics,
    authorized,
    isAuthenticating,
  ];

  const LoginState.initial()
    : this(
        loginStatus: LoginStatus.loggedOut,
        userDetail: null,
        isLoading: false,
        isSignup: false,
        authorized: 'Not Authorized',
        isAuthenticating: false,
        supportState: SupportState.unknown,
        availableBiometrics: const [],
        canCheckBiometrics: null,
      );

  LoginState copyWith({
    LoginStatus? loginStatus,
    UserModel? userDetail,
    bool? isLoading,
    bool? isSignup,

    SupportState? supportState,
    bool? canCheckBiometrics,
    List<BiometricType>? availableBiometrics,
    String? authorized,
    bool? isAuthenticating,
  }) => LoginState(
    loginStatus: loginStatus ?? this.loginStatus,
    userDetail: userDetail ?? this.userDetail,
    isLoading: isLoading ?? this.isLoading,
    isSignup: isSignup ?? this.isSignup,
    supportState: supportState ?? this.supportState,
    canCheckBiometrics: canCheckBiometrics ?? this.canCheckBiometrics,
    availableBiometrics: availableBiometrics ?? this.availableBiometrics,
    authorized: authorized ?? this.authorized,
    isAuthenticating: isAuthenticating ?? this.isAuthenticating,
  );
}
