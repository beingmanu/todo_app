import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/bloc/cswipe/cswipe_bloc.dart';
import 'package:todo_withbloc/src/presentation/widgets/cswipe_widget.dart';

import '../../config/theme/app_themes.dart';
import '../../utils/constants/colors.dart';

class CardSwipeScreen extends HookWidget {
  const CardSwipeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CswipeBloc>();
    final size = MediaQuery.of(context).size;
    CardSwiperController swipeController = CardSwiperController();
    useEffect(() {
      bloc.add(LoadCardsEvent());
      return null;
    }, [bloc.state.cards]);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => context.go(AppRoutes.profile),
      child: Scaffold(
        backgroundColor: PrimaryColors.k100,
        appBar: AppBar(
          title: Text(
            "Swipes",
            style: AppTheme.darkTheme.textTheme.displayLarge,
          ),
          toolbarHeight: 80,
        ),
        body: BlocConsumer<CswipeBloc, CswipeState>(
          listener: (context, state) {},
          builder: (context, state) {
            return state.isLoading
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: PrimaryColors.k600,
                      size: 40,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * .7,
                          width: size.width,
                          child: CardSwiper(
                            cardBuilder:
                                (
                                  context,
                                  index,
                                  horizontalOffsetPercentage,
                                  verticalOffsetPercentage,
                                ) => CswipeWidget(bloc.state.cards[index]),
                            cardsCount: bloc.state.cards.length,
                            controller: swipeController,
                            initialIndex: 0,
                            onSwipe:
                                (previousIndex, currentIndex, direction) async {
                                  switch (direction) {
                                    case CardSwiperDirection.left:
                                      context.read<CswipeBloc>().add(
                                        RejectCardEvent(
                                          bloc.state.cards[currentIndex ?? 0],
                                        ),
                                      );
                                      break;
                                    case CardSwiperDirection.right:
                                      context.read<CswipeBloc>().add(
                                        LikeCardEvent(
                                          bloc.state.cards[currentIndex ?? 0],
                                        ),
                                      );
                                      break;
                                    case CardSwiperDirection.top:
                                      context.read<CswipeBloc>().add(
                                        SaveCardEvent(
                                          bloc.state.cards[currentIndex ?? 0],
                                        ),
                                      );
                                      break;

                                    default:
                                  }
                                  return true;
                                },
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            //Undo
                            FloatingActionButton(
                              backgroundColor: PrimaryColors.kDefault,
                              shape: CircleBorder(),
                              onPressed: () => swipeController.undo(),
                              heroTag: "undo",
                              child: Icon(Icons.undo),
                            ),
                            // Like
                            FloatingActionButton(
                              backgroundColor: PrimaryColors.kDefault,
                              shape: CircleBorder(),
                              onPressed: () => swipeController.swipe(
                                CardSwiperDirection.right,
                              ),
                              heroTag: "like",
                              child: Icon(Icons.heart_broken),
                            ),
                            // reject
                            FloatingActionButton(
                              backgroundColor: PrimaryColors.kDefault,
                              shape: CircleBorder(),
                              heroTag: "reject",
                              onPressed: () => swipeController.swipe(
                                CardSwiperDirection.left,
                              ),
                              child: Icon(Icons.cancel),
                            ),

                            // save
                            FloatingActionButton(
                              backgroundColor: PrimaryColors.kDefault,
                              shape: CircleBorder(),
                              heroTag: "save",
                              onPressed: () => swipeController.swipe(
                                CardSwiperDirection.top,
                              ),
                              child: Icon(Icons.save),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
