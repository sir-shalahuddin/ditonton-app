part of 'tv_search_bloc.dart';

abstract class TvSearchState extends Equatable {
  const TvSearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends TvSearchState {}

class SearchLoading extends TvSearchState {}

class SearchError extends TvSearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHasData extends TvSearchState {
  final List<Tv> result;

  SearchHasData(this.result);

  @override
  List<Object> get props => [result];
}

class SearchHasNoData extends TvSearchState{
  final String message;

  SearchHasNoData(this.message);

  @override
  List<Object> get props => [message];
}
