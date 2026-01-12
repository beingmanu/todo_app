import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/domain/model/card_model.dart';

class CswipeWidget extends HookWidget {
  final CardModel card;
  const CswipeWidget(this.card, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(card.imageLink, fit: BoxFit.cover),

            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    card.title,
                    style: AppTheme.darkTheme.textTheme.displaySmall,
                  ),
                  Text(
                    card.subTitle,
                    style: AppTheme.darkTheme.textTheme.bodySmall,
                  ),
                  Text(
                    card.price,
                    style: AppTheme.darkTheme.textTheme.displaySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
