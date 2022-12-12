import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_watchlist_tvs.dart';

part 'watchlist_tv_event.dart';

part 'watchlist_tv_state.dart';

class WatchlistTvBloc
    extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTvs _getWatchlistTvs;

  WatchlistTvBloc(this._getWatchlistTvs)
      : super(const WatchlistEmpty('')) {
    on<WatchlistTvEvent>((event, emit) async {
      emit(WatchlistLoading());
      final result = await _getWatchlistTvs.execute();
      result.fold((failure) => emit(WatchlistError(failure.message)),
          (tvsData) {
        emit(WatchlistHasData(tvsData));
        if (tvsData.isEmpty) {
          emit(const WatchlistEmpty("Try to add some watchlist"));
        }
      });
    });
  }
}
