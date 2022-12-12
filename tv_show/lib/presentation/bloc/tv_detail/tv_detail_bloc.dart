import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/watchlist.dart';

import '../../../domain/usecases/get_tv_detail.dart';
import '../../../domain/usecases/get_tv_recommendations.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListTvStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: RequestState.Loading, message: ''));
      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendations.execute(event.id);

      detailResult.fold(
            (failure) async {
          emit(
            state.copyWith(
              tvDetailState: RequestState.Error,
              message: failure.message,
            ),
          );
        },
            (tv) async {
          emit(
            state.copyWith(
              tvRecommendationState: RequestState.Loading,
              tvDetail: tv,
              tvDetailState: RequestState.Loaded,
              message: '',
            ),
          );
          recommendationResult.fold(
                (failure) {
              emit(
                state.copyWith(
                  tvRecommendationState: RequestState.Error,
                  message: failure.message,
                ),
              );
            },
                (tvs) {
              emit(
                state.copyWith(
                  tvRecommendationState: RequestState.Loaded,
                  tvRecommendations: tvs,
                  message: '',
                ),
              );
            },
          );
        },
      );
    });
    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tvDetail);
      result.fold(
              (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
              (successMessage) {
            emit(state.copyWith(watchlistMessage: successMessage));
          }
      );

      add(LoadWatchlistStatus(event.tvDetail.id));

    });
    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tvDetail);

      result.fold(
              (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
              (successMessage) {
            emit(state.copyWith(watchlistMessage: successMessage));
          }
      );

      add(LoadWatchlistStatus(event.tvDetail.id));

    });
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
  }
}