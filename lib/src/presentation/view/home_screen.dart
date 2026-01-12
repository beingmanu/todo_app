import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_withbloc/src/config/router/router_helper.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/bloc/login/login_bloc.dart';
import 'package:todo_withbloc/src/presentation/bloc/todo/todo_state.dart';
import 'package:todo_withbloc/src/presentation/widgets/todo_widget.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';
import '../bloc/todo/todo_bloc.dart';
import '../widgets/filter_sheet.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    void showFilterSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,

        builder: (context) {
          return const FilterSheetContent();
        },
      );
    }

    return Scaffold(
      backgroundColor: PrimaryColors.k100,
      appBar: AppBar(
        title: Text("ToDos", style: AppTheme.darkTheme.textTheme.displayLarge),

        toolbarHeight: 80,
        actions: [
          BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.go(AppRoutes.profile),
                icon: Icon(Icons.child_care_outlined),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () =>
                    context.go(buildRoute(AppRoutes.todo, {"id": "New"})),
                child: TextField(
                  enabled: false,
                  // maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Write tasks...",
                    contentPadding: EdgeInsets.all(15),
                    suffixIcon: Icon(Icons.add),
                    fillColor: PrimaryColors.k300,
                    suffixIconConstraints: BoxConstraints(minWidth: 60),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: BlackAndWhiteColors.kGrey600,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tasks",
                    style: AppTheme.lightTheme.textTheme.displaySmall,
                  ),
                  IconButton(
                    onPressed: () => showFilterSheet(context),
                    icon: Icon(Icons.filter_alt_outlined),
                  ),
                ],
              ),
            ),
            BlocConsumer<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.todos.isEmpty) {
                  return Center(
                    child: LottieBuilder.asset(
                      "assets/icons/empty.json",
                      height: size.width * .5,
                    ),
                  );
                }
                return Column(
                  children: [
                    ...List.generate(
                      state.filteredTodos.length,
                      (index) => GestureDetector(
                        onTap: () {
                          context.go(
                            buildRoute(AppRoutes.todo, {
                              "id": index.toString(),
                            }),
                          );
                        },
                        child: TodoWidget(todo: state.filteredTodos[index]),
                      ),
                    ),
                  ],
                );
              },
              listener: (context, state) {},
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
