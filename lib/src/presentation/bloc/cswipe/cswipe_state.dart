part of 'cswipe_bloc.dart';

class CswipeState extends Equatable {
  final List<CardModel> cards;
  final List<CardModel> likedCards;
  final List<CardModel> rejectedCards;
  final List<CardModel> savedCards;
  final bool isLoading;
  final bool isSwipeEnds;
  const CswipeState({
    required this.cards,
    required this.rejectedCards,
    required this.likedCards,
    required this.savedCards,
    required this.isLoading,
    required this.isSwipeEnds,
  });

  @override
  List<Object> get props => [
    cards,
    likedCards,
    rejectedCards,
    savedCards,
    isLoading,
    isSwipeEnds,
  ];

  const CswipeState.initial()
    : this(
        cards: const [],
        rejectedCards: const [],
        likedCards: const [],
        savedCards: const [],
        isLoading: true,
        isSwipeEnds: false,
      );

  CswipeState copyWith({
    List<CardModel>? cards,
    List<CardModel>? likedCards,
    List<CardModel>? rejectedCards,
    List<CardModel>? savedCards,
    int? currentIndex,
    bool? isLoading,
    bool? isSwipeEnds,
  }) => CswipeState(
    cards: cards ?? this.cards,
    rejectedCards: rejectedCards ?? this.rejectedCards,
    likedCards: likedCards ?? this.likedCards,
    savedCards: savedCards ?? this.savedCards,
    isLoading: isLoading ?? this.isLoading,
    isSwipeEnds: isSwipeEnds ?? this.isSwipeEnds,
  );
}
