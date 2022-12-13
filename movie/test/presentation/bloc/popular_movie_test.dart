import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movies_bloc.dart';

import 'movie_list_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMoviesBloc popularMoviesBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMoviesBloc(mockGetPopularMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovieList = <Movie>[tMovie];

  test('Initial state should be empty', () {
    expect(popularMoviesBloc.state, PopularMoviesEmpty());
  });

  blocTest(
      'should emit [PopularMoviesLoaded, PopularMoviesLoading] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(PopularMoviesEvent()),
      expect: () =>
      [
        PopularMoviesLoading(),
        PopularMoviesLoaded(tMovieList)
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      }
  );

  blocTest(
      'should emit [PopularMoviesLoaded, PopularMoviesLoading] when error',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return popularMoviesBloc;
      },
      act: (bloc) => bloc.add(PopularMoviesEvent()),
      expect: () =>
      [
        PopularMoviesLoading(),
        const PopularMoviesError('Failed')
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      }
  );

  blocTest<PopularMoviesBloc, PopularMoviesState> (
    'Should emit [PopularMoviesLoading, PopularMoviesLoaded[], PopularMoviesEmpty] when data is gotten successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => const Right(<Movie>[]));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(PopularMoviesEvent()),
    expect: () => [
      PopularMoviesLoading(),
      const PopularMoviesLoaded(<Movie>[]),
      PopularMoviesEmpty(),
    ],
    verify: (bloc) {
      verify(mockGetPopularMovies.execute());
    },
  );
}
