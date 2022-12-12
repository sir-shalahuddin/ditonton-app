part of 'watchlist_movie_bloc.dart';


abstract class WatchlistMovieState extends Equatable {
  const WatchlistMovieState();

  @override
  List<Object> get props => [];
}

class WatchlistMovieEmpty extends WatchlistMovieState {
  final String message;

  const WatchlistMovieEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieLoading extends WatchlistMovieState {}

class WatchlistMovieError extends WatchlistMovieState {
  final String message;

  const WatchlistMovieError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistMovieHasData<Movie> extends WatchlistMovieState {
  final List<Movie> watchlistMovieResult;

  const WatchlistMovieHasData(this.watchlistMovieResult);

  @override
  List<Object> get props => [watchlistMovieResult];
}