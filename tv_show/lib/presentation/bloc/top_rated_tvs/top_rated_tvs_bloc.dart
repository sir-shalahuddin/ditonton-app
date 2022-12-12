import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_top_rated_tv.dart';


part 'top_rated_tvs_event.dart';

part 'top_rated_tvs_tate.dart';

class TopRatedTvsBloc extends Bloc<TopRatedTvsEvent, TopRatedTvsState> {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsBloc(this.getTopRatedTvs) : super(TopRatedTvsEmpty()) {
    on<TopRatedTvsEvent>((event, emit) async {
      emit(TopRatedTvsLoading());
      final result = await getTopRatedTvs.execute();
      result.fold((failure) => emit(TopRatedTvsError(failure.message)), (data) {
        emit(TopRatedTvsLoaded(data));
        if (data.isEmpty) emit(TopRatedTvsEmpty());
      });
    });
  }
}
