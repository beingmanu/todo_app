part of 'aplayer_bloc.dart';

class AplayerEvent extends Equatable {
  const AplayerEvent();

  @override
  List<Object> get props => [];
}

class LoadAudiosEvent extends AplayerEvent {
  @override
  List<Object> get props => [];
}

class PlayAudiosEvent extends AplayerEvent {
  final AudioModel audio;
  const PlayAudiosEvent(this.audio);
  @override
  List<Object> get props => [audio];
}

class ClearAudioStatesEvent extends AplayerEvent {
  @override
  List<Object> get props => [];
}

class UpdateStatusEvent extends AplayerEvent {
  final AudioStatus audioStatus;
  const UpdateStatusEvent(this.audioStatus);
  @override
  List<Object> get props => [audioStatus];
}
