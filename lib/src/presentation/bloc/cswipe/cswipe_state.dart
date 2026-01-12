part of 'cswipe_bloc.dart';

class CswipeState extends Equatable {
  final List<CardModel> cards;
  final List<CardModel> likedCards;
  final List<CardModel> rejectedCards;
  final List<CardModel> savedCards;
  final bool isLoading;
  const CswipeState({
    required this.cards,
    required this.rejectedCards,
    required this.likedCards,
    required this.savedCards,
    required this.isLoading,
  });

  @override
  List<Object> get props => [
    cards,
    likedCards,
    rejectedCards,
    savedCards,
    isLoading,
  ];

  const CswipeState.initial()
    : this(
        cards: const [],
        rejectedCards: const [],
        likedCards: const [],
        savedCards: const [],
        isLoading: true,
      );

  CswipeState copyWith({
    List<CardModel>? cards,
    List<CardModel>? likedCards,
    List<CardModel>? rejectedCards,
    List<CardModel>? savedCards,
    int? currentIndex,
    bool? isLoading,
  }) => CswipeState(
    cards: cards ?? this.cards,
    rejectedCards: likedCards ?? this.rejectedCards,
    likedCards: rejectedCards ?? this.likedCards,
    savedCards: savedCards ?? this.savedCards,
    isLoading: isLoading ?? this.isLoading,
  );
}
