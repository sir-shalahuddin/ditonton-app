import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/get_popular_tv.dart';

part 'popular_tvs_event.dart';

part 'popular_tvs_state.dart';

class PopularTvsBloc extends Bloc<PopularTvsEvent, PopularTvsState> {
  final GetPopularTvs getPopularTvs;

  PopularTvsBloc(this.getPopularTvs) : super(PopularTvsEmpty()) {
    on<PopularTvsEvent>((event, emit) async {
      emit(PopularTvsLoading());
      final result = await getPopularTvs.execute();
      result.fold((failure) => emit(PopularTvsError(failure.message)), (data) {
        emit(PopularTvsLoaded(data));
        if (data.isEmpty) emit(PopularTvsEmpty());
      });
    });
  }
}
