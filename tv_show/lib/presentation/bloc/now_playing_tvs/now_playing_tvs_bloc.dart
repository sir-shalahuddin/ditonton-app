import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv_show/domain/usecases/get_now_playing_tv.dart';

part 'now_playing_tvs_event.dart';

part 'now_playing_tvs_state.dart';

class NowPlayingTvsBloc extends Bloc<NowPlayingTvsEvent, NowPlayingTvState> {
  final GetNowPlayingTvs getNowPlayingTvs;

  NowPlayingTvsBloc(this.getNowPlayingTvs) : super(NowPlayingTvsEmpty()) {
    on<NowPlayingTvsEvent>((event, emit) async {
      emit(NowPlayingTvsLoading());
      final result = await getNowPlayingTvs.execute();
      result.fold((failure) => emit(NowPlayingTvsError(failure.message)),
          (data) {
        emit(NowPlayingTvsLoaded(data));
        if (data.isEmpty) emit(NowPlayingTvsEmpty());
      });
    });
  }
}
