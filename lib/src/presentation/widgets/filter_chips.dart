import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../config/theme/app_themes.dart';
import '../../utils/constants/colors.dart';

class FilterChipsWidget extends HookWidget {
  final bool isSelected;
  final String value;
  final void Function(bool isse)? onSelected;
  const FilterChipsWidget({
    super.key,
    required this.isSelected,
    required this.value,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      labelPadding: EdgeInsets.zero,
      labelStyle: isSelected
          ? AppTheme.lightTheme.textTheme.labelMedium!.copyWith(
              color: PrimaryColors.k100,
            )
          : AppTheme.lightTheme.textTheme.labelMedium,
      label: Text(value),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      selectedColor: PrimaryColors.k600,
      padding: EdgeInsets.symmetric(horizontal: 10),
      selected: isSelected,
      onSelected: onSelected,
    );
  }
}
