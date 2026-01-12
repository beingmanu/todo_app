import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../utils/constants/colors.dart';

class AddTodoWidget extends HookWidget {
  final TextEditingController taskController;
  const AddTodoWidget({super.key, required this.taskController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: taskController,

      maxLines: null,
      // 2. Sets the keyboard to a type that supports multi-line
      keyboardType: TextInputType.multiline,
      // 3. Changes the "Done" button to a "Return/New Line" icon
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        hintText: "write tasks...",
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        fillColor: PrimaryColors.k300,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey600),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: BlackAndWhiteColors.kGrey600),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PrimaryColors.k600),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
