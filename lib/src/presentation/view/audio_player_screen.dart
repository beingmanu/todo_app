import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:todo_withbloc/src/config/router/routes.dart';
import 'package:todo_withbloc/src/config/theme/app_themes.dart';
import 'package:todo_withbloc/src/presentation/bloc/aplayer/aplayer_bloc.dart';
import 'package:todo_withbloc/src/utils/constants/colors.dart';

class AudioPlayerScreen extends HookWidget {
  const AudioPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AplayerBloc>();
    final size = MediaQuery.of(context).size;
    useEffect(() {
      bloc.add(LoadAudiosEvent());

      return null;
    }, [bloc.state.audios]);
    return BlocConsumer<AplayerBloc, AplayerState>(
      listener: (context, state) {},
      // buildWhen: (previous, current) =>
      //     previous.audioStatus != current.audioStatus,
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            context.read<AplayerBloc>().add(ClearAudioStatesEvent());
            context.go(AppRoutes.profile);
          },

          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "Trending IG Audios",
                style: AppTheme.lightTheme.textTheme.displayMedium!.copyWith(
                  color: PrimaryColors.kDefault,
                  fontWeight: FontWeight.w600,
                ),
              ),

              leading: IconButton(
                onPressed: () {
                  context.read<AplayerBloc>().add(ClearAudioStatesEvent());
                  context.go(AppRoutes.profile);
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: PrimaryColors.kDefault,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<AplayerBloc>().add(ClearAudioStatesEvent());
                    context.go(AppRoutes.profile);
                  },
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: PrimaryColors.kDefault,
                  ),
                ),
              ],
              backgroundColor: PrimaryColors.k50,
            ),
            backgroundColor: PrimaryColors.k50,
            body: state.isLoading
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      color: PrimaryColors.k600,
                      size: 40,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Instagram Trends",
                            style: AppTheme.lightTheme.textTheme.displaySmall!
                                .copyWith(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: PrimaryColors.k400),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(Icons.info_outline),
                                SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    "Discover daily trending instagram audios, use them to boost your content & gain more reach",
                                    style: AppTheme
                                        .lightTheme
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          ...List.generate(
                            state.audios.length,
                            (index) => AudioWidget(index: index),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class AudioWidget extends HookWidget {
  final int index;
  const AudioWidget({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AplayerBloc, AplayerState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Card(
          surfaceTintColor: Colors.transparent,
          color: BackgroundColor.kPurple.withValues(alpha: 0.3),

          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://images.unsplash.com/photo-1560343090-f0409e92791a?q=80&w=764&auto=format&fit=crop",
                          fit: BoxFit.cover,
                        ),
                        Center(
                          child:
                              state.audioStatus == AudioStatus.loading &&
                                  state.currentAudio!.sId ==
                                      state.audios[index].sId
                              ? CircularProgressIndicator(color: Colors.white)
                              : IconButton(
                                  onPressed: () {
                                    context.read<AplayerBloc>().add(
                                      PlayAudiosEvent(state.audios[index]),
                                    );
                                  },
                                  icon: Icon(
                                    state.audioStatus == AudioStatus.playing &&
                                            state.currentAudio!.sId ==
                                                state.audios[index].sId
                                        ? Icons.pause
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.audios[index].title,
                        style: AppTheme.lightTheme.textTheme.bodyLarge,
                      ),
                      Text(
                        state.audios[index].singer,
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                      SizedBox(height: 20),

                      Row(
                        children: [
                          Icon(
                            Icons.arrow_outward_rounded,
                            size: 15,
                            color: PrimaryColors.kDefault,
                          ),
                          Text(
                            "View on instagram",
                            style: AppTheme.lightTheme.textTheme.bodySmall!
                                .copyWith(
                                  color: PrimaryColors.kDefault,
                                  decoration: TextDecoration.underline,
                                  decorationColor: PrimaryColors.kDefault,

                                  // decorationThickness: 2.0,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
