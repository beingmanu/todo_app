import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:todo_withbloc/src/domain/model/audio_model.dart';

import '../../../utils/toast_util.dart';

part 'aplayer_event.dart';
part 'aplayer_state.dart';

class AplayerBloc extends Bloc<AplayerEvent, AplayerState> {
  final AudioPlayer _player = AudioPlayer();
  AplayerBloc() : super(AplayerState.initial()) {
    _player.playerStateStream.listen((pevent) {
      if (pevent.processingState == ProcessingState.completed &&
          state.currentAudio != null) {
        _player.stop();
        add(UpdateStatusEvent(AudioStatus.complete));
      }
    });
    on<LoadAudiosEvent>((event, emit) async {
      try {
        final String response = await rootBundle.loadString(
          'assets/files/audios.json',
        );

        final List<dynamic> data = json.decode(response);

        final List<AudioModel> audiosList = data
            .map((json) => AudioModel.fromMap(json))
            .toList();

        emit(state.copyWith(audios: audiosList, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        ToastService().error(e.toString());
      }
    });

    on<PlayAudiosEvent>((event, emit) async {
      try {
        if (event.audio.sId == state.currentAudio?.sId &&
            state.audioStatus != AudioStatus.initial) {
          if (state.audioStatus == AudioStatus.complete) {
            _player.seek(Duration.zero);
            _player.play();
            emit(state.copyWith(audioStatus: AudioStatus.playing));
          } else if (state.audioStatus == AudioStatus.paused) {
            _player.play();
            emit(state.copyWith(audioStatus: AudioStatus.playing));
          } else {
            _player.pause();
            emit(state.copyWith(audioStatus: AudioStatus.paused));
          }
        } else {
          emit(state.copyWith(currentAudio: event.audio));
          if (event.audio.audioUrl.startsWith('assets/')) {
            await _player.setAsset(event.audio.audioUrl);
          } else {
            emit(state.copyWith(audioStatus: AudioStatus.loading));
            await _player.setUrl(event.audio.audioUrl);
          }

          _player.play();
          emit(state.copyWith(audioStatus: AudioStatus.playing));
        }
      } catch (e) {
        _player.stop();
        emit(
          state.copyWith(
            audioStatus: AudioStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    });
    on<ClearAudioStatesEvent>((event, emit) async {
      _player.stop();
      _player.clearAudioSources();

      emit(
        state.copyWith(
          audioStatus: AudioStatus.initial,
          currentAudio: null,
          errorMessage: "",
          isLoading: false,
        ),
      );
    });
    on<UpdateStatusEvent>((event, emit) {
      emit(state.copyWith(audioStatus: event.audioStatus));
    });
  }
}
