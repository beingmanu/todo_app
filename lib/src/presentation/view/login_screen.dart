import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';
import 'package:todo_withbloc/src/presentation/widgets/main_button.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController pinController = useTextEditingController();
    final bloc = context.read<LoginBloc>();
    useEffect(() {
      bloc.add(CheckLoginEvent());

      final subscription = bloc.stream.listen((state) {
        if (!bloc.state.isSignup &&
            state.loginStatus == LoginStatus.askingpin &&
            state.userDetail != null) {
          usernameController.text = state.userDetail!.userName;
        }
      });
      return subscription.cancel;
    }, [bloc.state.loginStatus]);

    return Scaffold(
      extendBody: true,

      bottomSheet: Padding(
        padding: const EdgeInsets.only(
          top: kToolbarHeight,
          bottom: 20,
          left: 20,
          right: 20,
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {},
              buildWhen: (previous, current) =>
                  previous.isSignup != current.isSignup,
              builder: (context, state) {
                return TextField(
                  textAlign: TextAlign.center,
                  controller: usernameController,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,

                  decoration: InputDecoration(
                    hintText: "User Name",
                    border: InputBorder.none,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {},
              builder: (context, state) {
                return TextField(
                  textAlign: TextAlign.center,
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  style: AppTheme.lightTheme.textTheme.bodyLarge,

                  decoration: InputDecoration(
                    hintText: "Pin",
                    border: InputBorder.none,
                  ),
                );
              },
            ),

            SizedBox(height: 40),
            BlocConsumer<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isSignup != current.isSignup,
              listener: (context, state) {},
              builder: (context, state) {
                return RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium, // Default style for the whole sentence
                    children: [
                      TextSpan(
                        text: state.isSignup
                            ? 'Already a user? '
                            : 'New to here? ',
                      ),
                      TextSpan(
                        text: state.isSignup ? 'LogIn' : 'SignUp',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            context.read<LoginBloc>().add(ToggleSignupEvent());

                            pinController.clear();
                            usernameController.clear();

                            if (state.isSignup &&
                                bloc.state.loginStatus ==
                                    LoginStatus.askingpin) {
                              bloc.add(CheckLoginEvent());
                              usernameController.text =
                                  bloc.state.userDetail!.userName;
                            }
                          },
                      ),
                    ],
                  ),
                );
              },
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state.loginStatus == LoginStatus.loggedIn) {
                  context.go(AppRoutes.home);
                }
              },
              builder: (context, state) {
                return MainButton(
                  isLoading: state.isLoading,
                  title: state.isSignup ? "Signup" : "Login",
                  onPressed: () {
                    if (state.isSignup) {
                      context.read<LoginBloc>().add(
                        DoSignUpEvent(
                          pin: pinController.text,
                          username: usernameController.text,
                        ),
                      );
                    } else {
                      context.read<LoginBloc>().add(
                        DoLoginEvent(
                          pin: pinController.text,
                          username: usernameController.text,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: kToolbarHeight,
              bottom: 20,
              left: 20,
              right: 20,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  "Simplify",
                  style: AppTheme.lightTheme.textTheme.displayLarge,
                ),
                Text(
                  "One task at a time.",
                  style: AppTheme.lightTheme.textTheme.displayMedium,
                ),
                SizedBox(height: 10),
                Text(
                  "Your mind is for having ideas, not holding them. Log in to clear the clutter and find your focus.",
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),

                SizedBox(height: 40),

                LottieBuilder.asset("assets/icons/task_loader.json"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
