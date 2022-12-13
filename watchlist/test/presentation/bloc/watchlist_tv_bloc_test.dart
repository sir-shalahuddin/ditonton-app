import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_tv_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistTvs])
void main() {
  late WatchlistTvBloc watchlistTvBloc;
  late MockGetWatchlistTvs mockGetWatchlistTvs;

  setUp(() {
    mockGetWatchlistTvs = MockGetWatchlistTvs();
    watchlistTvBloc = WatchlistTvBloc(mockGetWatchlistTvs);
  });

  test('initial should be empty', () {
    expect(watchlistTvBloc.state,
        const WatchlistEmpty(''));
  });

  final testTvs = <Tv>[testTv];

  blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistLoading, WatchlistTvHasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Right(testTvs));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvEvent()),
      expect: () =>
      [WatchlistLoading(), WatchlistHasData(testTvs)],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistLoading, WatchlistTvEmpty] when data is gotten empty',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => const Right(<Tv>[]));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvEvent()),
      expect: () =>
      [WatchlistLoading(),const WatchlistHasData(<Tv>[]) ,const WatchlistEmpty("Try to add some watchlist")],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });

  blocTest<WatchlistTvBloc, WatchlistTvState>(
      'Should emit [WatchlistLoading, WatchlistTvError] when data is gotten Error',
      build: () {
        when(mockGetWatchlistTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistTvBloc;
      },
      act: (bloc) => bloc.add(WatchlistTvEvent()),
      expect: () =>
      [WatchlistLoading(), const WatchlistError('Server Failure')],
      verify: (bloc) {
        verify(mockGetWatchlistTvs.execute());
      });
}
