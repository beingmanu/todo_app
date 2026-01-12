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
  const LikeCardEvent(this.card);

  @override
  List<Object> get props => [card];
}

class RejectCardEvent extends CswipeEvent {
  final CardModel card;
  const RejectCardEvent(this.card);

  @override
  List<Object> get props => [card];
}

class SaveCardEvent extends CswipeEvent {
  final CardModel card;
  const SaveCardEvent(this.card);

  @override
  List<Object> get props => [card];
}

class SwipeDownEvent extends CswipeEvent {
  final CardModel card;
  const SwipeDownEvent(this.card);

  @override
  List<Object> get props => [card];
}
