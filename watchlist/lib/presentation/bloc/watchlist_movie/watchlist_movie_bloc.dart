import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_watchlist_movies.dart';

part 'watchlist_movie_event.dart';

part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovies;

  WatchlistMovieBloc(this._getWatchlistMovies)
      : super(const WatchlistMovieEmpty('')) {
    on<WatchlistMovieEvent>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await _getWatchlistMovies.execute();
      result.fold((failure) => emit(WatchlistMovieError(failure.message)),
          (moviesData) {
        emit(WatchlistMovieHasData(moviesData));
        if (moviesData.isEmpty) {
          emit(const WatchlistMovieEmpty("Try to add some watchlist"));
        }
      });
    });
  }
}
