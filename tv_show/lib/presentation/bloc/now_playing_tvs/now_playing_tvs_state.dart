part of 'now_playing_tvs_bloc.dart';

abstract class NowPlayingTvState extends Equatable {
  const NowPlayingTvState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvsEmpty extends NowPlayingTvState {}

class NowPlayingTvsLoading extends NowPlayingTvState {}

class NowPlayingTvsLoaded extends NowPlayingTvState {
  final List<Tv> tv;

  const NowPlayingTvsLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}

class NowPlayingTvsError extends NowPlayingTvState {
  final String message;

  const NowPlayingTvsError(this.message);

  @override
  List<Object> get props => [message];
}