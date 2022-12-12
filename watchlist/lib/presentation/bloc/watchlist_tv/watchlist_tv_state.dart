part of 'watchlist_tv_bloc.dart';


abstract class WatchlistTvState extends Equatable {
  const WatchlistTvState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistTvState {
  final String message;

  const WatchlistEmpty(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistLoading extends WatchlistTvState {}

class WatchlistError extends WatchlistTvState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData<Tv> extends WatchlistTvState {
  final List<Tv> watchlistResult;

  const WatchlistHasData(this.watchlistResult);

  @override
  List<Object> get props => [watchlistResult];
}