import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:todo_withbloc/src/utils/toast_util.dart';

import '../../../domain/model/card_model.dart';

part 'cswipe_event.dart';
part 'cswipe_state.dart';

class CswipeBloc extends Bloc<CswipeEvent, CswipeState> {
  CswipeBloc() : super(CswipeState.initial()) {
    on<LoadCardsEvent>((event, emit) async {
      try {
        final String response = await rootBundle.loadString(
          'assets/files/products.json',
        );

        final List<dynamic> data = json.decode(response);

        final List<CardModel> cardsList = data
            .map((json) => CardModel.fromMap(json))
            .toList();

        emit(state.copyWith(cards: cardsList, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false));
        ToastService().error(e.toString());
      }
    });

    on<SaveCardEvent>((event, emit) {
      if (state.savedCards.contains(event.card)) {
        ToastService().error("Already Saved");
      } else {
        emit(state.copyWith(savedCards: [...state.savedCards, event.card]));
        ToastService().success("Saved");
      }
    });
    on<LikeCardEvent>((event, emit) {
      if (state.likedCards.contains(event.card)) {
        ToastService().error("Already Liked");
      } else {
        emit(state.copyWith(likedCards: [...state.likedCards, event.card]));
        ToastService().success("Liked");
      }
    });
    on<RejectCardEvent>((event, emit) {
      if (state.rejectedCards.contains(event.card)) {
        ToastService().error("Already Rejected");
      } else {
        emit(
          state.copyWith(rejectedCards: [...state.rejectedCards, event.card]),
        );
        ToastService().success("Rejected");
      }
    });
    on<SwipeDownEvent>((event, emit) {
      ToastService().success("Nothing");
    });
  }
}
