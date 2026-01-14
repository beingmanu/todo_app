import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/presentation/bloc/cswipe/cswipe_bloc.dart';
import 'package:todo_withbloc/src/presentation/widgets/cswipe_widget.dart';

import '../../config/theme/app_themes.dart';
import '../../utils/constants/colors.dart';
import '../widgets/gradient_widget.dart';

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
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            "Swipes",
            style: AppTheme.darkTheme.textTheme.displayLarge,
          ),
          toolbarHeight: 80,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => BlocConsumer<CswipeBloc, CswipeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      return Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Liked...",

                                style:
                                    AppTheme.lightTheme.textTheme.displayMedium,
                              ),
                            ),
                            ...List.generate(
                              state.likedCards.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(state.likedCards[index].title),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Rejected...",
                                style:
                                    AppTheme.lightTheme.textTheme.displayMedium,
                              ),
                            ),
                            ...List.generate(
                              state.rejectedCards.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(state.rejectedCards[index].title),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Saved...",
                                style:
                                    AppTheme.lightTheme.textTheme.displayMedium,
                              ),
                            ),
                            ...List.generate(
                              state.savedCards.length,
                              (index) => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(state.savedCards[index].title),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
              icon: Icon(Icons.menu),
            ),
          ],
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
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      OceanWaveWidget(),

                      Container(
                        height: size.height * .8,
                        width: size.width,
                        alignment: Alignment.center,
                      ).blurred(
                        blur: 40,
                        blurColor: PrimaryColors.k50,
                        colorOpacity: 0.1,
                      ),
                      state.isSwipeEnds
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset(
                                    "assets/icons/empty.json",
                                    height: size.width * .5,
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "No More Products",
                                    style: AppTheme
                                        .lightTheme
                                        .textTheme
                                        .displayMedium,
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                        ) => CswipeWidget(
                                          bloc.state.cards[index],
                                        ),
                                    cardsCount: bloc.state.cards.length,
                                    controller: swipeController,
                                    initialIndex: 0,
                                    allowedSwipeDirection:
                                        AllowedSwipeDirection.only(
                                          left: true,
                                          right: true,
                                          up: true,
                                        ),
                                    isLoop: false,
                                    onEnd: () => context.read<CswipeBloc>().add(
                                      UpdateSwipeEnd(true),
                                    ),
                                    onUndo:
                                        (
                                          previousIndex,
                                          currentIndex,
                                          direction,
                                        ) {
                                          switch (direction) {
                                            case CardSwiperDirection.left:
                                              context.read<CswipeBloc>().add(
                                                RejectCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[currentIndex],
                                                  isUndo: true,
                                                ),
                                              );
                                              break;
                                            case CardSwiperDirection.right:
                                              context.read<CswipeBloc>().add(
                                                LikeCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[currentIndex],
                                                  isUndo: true,
                                                ),
                                              );
                                              break;
                                            case CardSwiperDirection.top:
                                              context.read<CswipeBloc>().add(
                                                SaveCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[currentIndex],
                                                  isUndo: true,
                                                ),
                                              );
                                              break;

                                            default:
                                          }
                                          if ((state.cards.length - 1) ==
                                              previousIndex) {
                                            context.read<CswipeBloc>().add(
                                              UpdateSwipeEnd(false),
                                            );
                                          }
                                          return true;
                                        },

                                    onSwipe:
                                        (
                                          previousIndex,
                                          currentIndex,
                                          direction,
                                        ) async {
                                          switch (direction) {
                                            case CardSwiperDirection.left:
                                              context.read<CswipeBloc>().add(
                                                RejectCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[previousIndex],
                                                ),
                                              );
                                              break;
                                            case CardSwiperDirection.right:
                                              context.read<CswipeBloc>().add(
                                                LikeCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[previousIndex],
                                                ),
                                              );
                                              break;
                                            case CardSwiperDirection.top:
                                              context.read<CswipeBloc>().add(
                                                SaveCardEvent(
                                                  bloc
                                                      .state
                                                      .cards[previousIndex],
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                    ],
                  );
          },
        ),
      ),
    );
  }
}
