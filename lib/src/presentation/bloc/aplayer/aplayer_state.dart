part of 'aplayer_bloc.dart';

enum AudioStatus { initial, loading, playing, paused, stopped, error, complete }

class AplayerState extends Equatable {
  final List<AudioModel> audios;
  final bool isLoading;
  final AudioStatus audioStatus;
  final AudioModel? currentAudio;
  final String? errorMessage;

  const AplayerState({
    required this.isLoading,
    required this.audios,
    required this.audioStatus,
    this.currentAudio,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
    audios,
    isLoading,
    audioStatus,
    currentAudio,
    errorMessage,
  ];

  const AplayerState.initial()
    : this(
        audioStatus: AudioStatus.initial,
        audios: const [],
        isLoading: true,
        currentAudio: null,
        errorMessage: null,
      );
  AplayerState copyWith({
    List<AudioModel>? audios,
    bool? isLoading,
    AudioStatus? audioStatus,
    AudioModel? currentAudio,
    String? errorMessage,
  }) => AplayerState(
    isLoading: isLoading ?? this.isLoading,
    audios: audios ?? this.audios,
    audioStatus: audioStatus ?? this.audioStatus,
    currentAudio: currentAudio ?? this.currentAudio,
    errorMessage: errorMessage ?? this.errorMessage,
  );
}
