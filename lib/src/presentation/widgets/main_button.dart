import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/constants/colors.dart';

class MainButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool isLoading;
  final String title;
  const MainButton({
    super.key,
    this.onPressed,
    this.isLoading = false,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: PrimaryColors.k600,
        fixedSize: Size(size.width * .8, 40),
      ),
      onPressed: onPressed,
      child: isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: PrimaryColors.k100,
              size: 40,
            )
          : Text(title, style: TextStyle(color: PrimaryColors.k100)),
    );
  }
}
