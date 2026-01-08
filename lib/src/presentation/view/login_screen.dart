import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final TextEditingController usernameController = useTextEditingController();
    final TextEditingController pinController = useTextEditingController();
    final bloc = context.read<LoginBloc>();
    useEffect(() {
      bloc.add(CheckLoginEvent());

      final subscription = bloc.stream.listen((state) {
        if (state.loginStatus == LoginStatus.askingpin &&
            state.userDetail != null) {
          usernameController.text = state.userDetail!.userName;
        }
      });

      return subscription.cancel;
    }, [bloc.state.loginStatus]);

    return Scaffold(
      backgroundColor: PrimaryColors.k100,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: BlocConsumer<LoginBloc, LoginState>(
          buildWhen: (previous, current) =>
              previous.isSignup != current.isSignup,
          listener: (context, state) {},
          builder: (context, state) {
            return Text(state.isSignup ? "Signup" : "Login");
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
              child: CircleAvatar(
                maxRadius: size.width * .1,
                backgroundColor: BackgroundColor.kLightPurple,
                child: Icon(Icons.person, size: size.width * .1),
              ),
            ),
            SizedBox(height: 40),

            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {},
              // buildWhen: (previous, current) => ,
              builder: (context, state) {
                return TextField(
                  textAlign: TextAlign.center,
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "User Name",
                    border: InputBorder.none,
                  ),
                );
              },
            ),
            BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {},
              builder: (context, state) {
                return TextField(
                  textAlign: TextAlign.center,
                  controller: pinController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Pin",
                    border: InputBorder.none,
                  ),
                );
              },
            ),
            Spacer(),

            BlocConsumer<LoginBloc, LoginState>(
              buildWhen: (previous, current) =>
                  previous.isSignup != current.isSignup,
              listener: (context, state) {},
              builder: (context, state) {
                return TextButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(ToggleSignupEvent());
                    usernameController.clear();
                    pinController.clear();
                    if (!state.isSignup) {
                      bloc.add(CheckLoginEvent());

                      if (bloc.state.loginStatus == LoginStatus.loggedIn) {
                        usernameController.text =
                            bloc.state.userDetail!.userName;
                      }
                    }
                  },
                  child: Text(state.isSignup ? "Login ?" : "Signup ?"),
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
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColors.k600,
                    fixedSize: Size(size.width * .8, 40),
                  ),
                  onPressed: () {
                    if (state.isSignup) {
                      context.read<LoginBloc>().add(
                        DoSignUpEvent(
                          pin: int.tryParse(pinController.text) ?? 0,
                          username: usernameController.text,
                        ),
                      );
                    } else {
                      context.read<LoginBloc>().add(
                        DoLoginEvent(
                          pin: int.tryParse(pinController.text) ?? 0,
                          username: usernameController.text,
                        ),
                      );
                    }
                  },
                  child: state.isLoading
                      ? CircularProgressIndicator(color: PrimaryColors.k100)
                      : Text(
                          state.isSignup ? "Signup" : "Login",
                          style: TextStyle(color: PrimaryColors.k100),
                        ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
