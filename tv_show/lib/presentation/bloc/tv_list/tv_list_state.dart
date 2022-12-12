part of 'tv_list_bloc.dart';


abstract class TvListState extends Equatable {
  const TvListState();

  @override
  List<Object> get props => [];
}

class TvListEmpty extends TvListState {}

class TvListLoading extends TvListState {}

class TvListLoaded extends TvListState {
  final List<Tv> tvs;

  const TvListLoaded(this.tvs);

  @override
  List<Object> get props => [tvs];
}

class TvListError extends TvListState {
  final String message;

  const TvListError(this.message);

  @override
  List<Object> get props => [message];
}
