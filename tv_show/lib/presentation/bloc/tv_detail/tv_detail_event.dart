part of 'tv_detail_bloc.dart';

abstract class TvDetailEvent extends Equatable {
  const TvDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  const FetchTvDetail(this.id);

  @override
  List<Object> get props => [id];
}

class AddToWatchlist extends TvDetailEvent {
  final TvDetail tvDetail;

  const AddToWatchlist(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tvDetail;

  const RemoveFromWatchlist(this.tvDetail);

  @override
  List<Object> get props => [tvDetail];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  const LoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}