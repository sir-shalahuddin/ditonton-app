import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_now_playing_tv.dart';
import '../../../domain/usecases/get_popular_tv.dart';
import '../../../domain/usecases/get_top_rated_tv.dart';


part 'tv_list_event.dart';
part 'tv_list_state.dart';

class NowPlayingTvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetNowPlayingTvs getNowPlayingTvs;
  NowPlayingTvListBloc(this.getNowPlayingTvs) : super(TvListEmpty()) {
    on<TvListEvent>((event, emit) async {
      emit(TvListLoading());
      final result = await getNowPlayingTvs.execute();
      result.fold(
            (failure) => emit(TvListError(failure.message)),
            (tvsData) => emit(TvListLoaded(tvsData)),
      );
    });
  }
}

class PopularTvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetPopularTvs getPopularTvs;
  PopularTvListBloc(this.getPopularTvs) : super(TvListEmpty()) {
    on<TvListEvent>((event, emit) async {
      emit(TvListLoading());
      final result = await getPopularTvs.execute();
      result.fold(
            (failure) => emit(TvListError(failure.message)),
            (tvsData) => emit(TvListLoaded(tvsData)),
      );
    });
  }
}

class TopRatedTvListBloc extends Bloc<TvListEvent, TvListState> {
  final GetTopRatedTvs getTopRatedTvs;
  TopRatedTvListBloc(this.getTopRatedTvs) : super(TvListEmpty()) {
    on<TvListEvent>((event, emit) async {
      emit(TvListLoading());
      final result = await getTopRatedTvs.execute();
      result.fold(
            (failure) => emit(TvListError(failure.message)),
            (tvsData) => emit(TvListLoaded(tvsData)),
      );
    });
  }
}