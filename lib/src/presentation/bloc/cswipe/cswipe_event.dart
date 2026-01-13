part of 'cswipe_bloc.dart';

class CswipeEvent extends Equatable {
  const CswipeEvent();

  @override
  List<Object> get props => [];
}

class LoadCardsEvent extends CswipeEvent {
  const LoadCardsEvent();

  @override
  List<Object> get props => [];
}

class LikeCardEvent extends CswipeEvent {
  final CardModel card;
  final bool isUndo;
  const LikeCardEvent(this.card, {this.isUndo = false});

  @override
  List<Object> get props => [card, isUndo];
}

class RejectCardEvent extends CswipeEvent {
  final CardModel card;
  final bool isUndo;
  const RejectCardEvent(this.card, {this.isUndo = false});

  @override
  List<Object> get props => [card];
}

class SaveCardEvent extends CswipeEvent {
  final CardModel card;
  final bool isUndo;
  const SaveCardEvent(this.card, {this.isUndo = false});

  @override
  List<Object> get props => [card];
}

class UpdateSwipeEnd extends CswipeEvent {
  final bool isSwipeEnd;
  const UpdateSwipeEnd(this.isSwipeEnd);

  @override
  List<Object> get props => [isSwipeEnd];
}
