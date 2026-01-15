import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';

import '../../utils/constants/colors.dart';

class ProfileScreen extends HookWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => context.go(AppRoutes.home),
      child: Scaffold(
        backgroundColor: PrimaryColors.k100,
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: size.width * .22,
                    width: size.width,
                    color: PrimaryColors.kDefault,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.only(left: (size.width * .2) + 30),
                    child: Text(
                      context.read<LoginBloc>().state.userDetail?.userName ??
                          "",
                      style: AppTheme.darkTheme.textTheme.displaySmall,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: size.width * .09, left: 15),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: size.width * .1,
                      backgroundColor: PrimaryColors.k800,
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "More Features",
                      style: AppTheme.lightTheme.textTheme.displaySmall,
                    ),

                    FeaturesWidget(
                      "Card Swipe",
                      () => context.go(AppRoutes.cSwipe),
                      icon: Icons.copy,
                    ),
                    FeaturesWidget("Trending Audios", () {
                      context.go(AppRoutes.aPlayer);
                    }, icon: Icons.music_note),
                    Text(
                      "Profile Options",
                      style: AppTheme.lightTheme.textTheme.displaySmall,
                    ),

                    FeaturesWidget("Log out", () {
                      context.read<LoginBloc>().add(DoLogOutEvent());
                      context.go(AppRoutes.login);
                    }, icon: Icons.logout),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeaturesWidget extends HookWidget {
  final String title;
  final void Function()? onTap;
  final IconData? icon;
  const FeaturesWidget(this.title, this.onTap, {super.key, this.icon});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        color: PrimaryColors.k400,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon ?? Icons.person),
              SizedBox(width: 10),
              Text(title, style: AppTheme.lightTheme.textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}
