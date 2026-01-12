import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/widgets/main_button.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';

import '../../domain/model/todo_model.dart';
import '../bloc/todo/todo_bloc.dart';
import '../bloc/todo/todo_event.dart';
import 'filter_chips.dart';

class FilterSheetContent extends HookWidget {
  const FilterSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    // Watch the bloc to get current selections for the UI (Checkmarks/Colors)
    final state = context.watch<TodoBloc>().state;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filter by Category",
                style: AppTheme.lightTheme.textTheme.displaySmall,
              ),
              TextButton(
                onPressed: () {
                  context.read<TodoBloc>().add(UpdateFilter(isClear: true));
                  context.pop();
                },

                child: Text(
                  "Clear",
                  style: AppTheme.lightTheme.textTheme.bodyLarge!.copyWith(
                    color: ExtraShades.kPink,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: TodoCategories.values.map((cat) {
              final isSelected = state.selectedCategories.contains(cat);
              return FilterChipsWidget(
                isSelected: isSelected,
                value: cat.value,
                onSelected: (isse) => context.read<TodoBloc>().add(
                  UpdateFilter(selectedCategories: cat),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            "Filter by Status",
            style: AppTheme.lightTheme.textTheme.displaySmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            children: TodoCompletion.values.map((status) {
              final isSelected = state.selectedStatuses.contains(status);
              return FilterChipsWidget(
                isSelected: isSelected,
                value: status.value,
                onSelected: (isse) => context.read<TodoBloc>().add(
                  UpdateFilter(selectedStatuses: status),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 30),
          MainButton(title: "Done", onPressed: () => context.pop()),
        ],
      ),
    );
  }
}
