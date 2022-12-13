import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:watchlist/watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistMovieBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  test('initial should be empty', () {
    expect(watchlistMovieBloc.state,
        const WatchlistMovieEmpty(''));
  });

  final testMovies = <Movie>[testMovie];

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistLoading, WatchlistMovieHasData] when data is gotten successfully',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right(testMovies));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieEvent()),
      expect: () =>
          [WatchlistMovieLoading(), WatchlistMovieHasData(testMovies)],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistLoading, WatchlistMovieEmpty] when data is gotten empty',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Right(<Movie>[]));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieEvent()),
      expect: () =>
          [WatchlistMovieLoading(),const WatchlistMovieHasData(<Movie>[]) ,const WatchlistMovieEmpty("Try to add some watchlist")],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });

  blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'Should emit [WatchlistLoading, WatchlistMovieError] when data is gotten error',
      build: () {
        when(mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(WatchlistMovieEvent()),
      expect: () =>
      [WatchlistMovieLoading(), const WatchlistMovieError('Server Failure')],
      verify: (bloc) {
        verify(mockGetWatchlistMovies.execute());
      });
}
