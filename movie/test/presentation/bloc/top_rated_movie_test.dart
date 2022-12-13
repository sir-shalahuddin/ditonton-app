import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';

import 'movie_list_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMoviesBloc topRatedMoviesBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMoviesBloc(mockGetTopRatedMovies);
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
    expect(topRatedMoviesBloc.state, TopRatedMoviesEmpty());
  });

  blocTest(
      'should emit [TopRatedMoviesLoaded, TopRatedMoviesLoading] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedMoviesBloc;
      },
      act: (bloc) => bloc.add(TopRatedMoviesEvent()),
      expect: () =>
      [
        TopRatedMoviesLoading(),
        TopRatedMoviesLoaded(tMovieList)
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      }
  );

  blocTest(
      'should emit [TopRatedMoviesLoaded, TopRatedMoviesLoading] when error',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return topRatedMoviesBloc;
      },
      act: (bloc) => bloc.add(TopRatedMoviesEvent()),
      expect: () =>
      [
        TopRatedMoviesLoading(),
        const TopRatedMoviesError('Failed')
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      }
  );

  blocTest<TopRatedMoviesBloc, TopRatedMoviesState> (
    'Should emit [TopRatedMoviesLoading, TopRatedMoviesLoaded[], TopRatedMoviesEmpty] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedMovies.execute())
          .thenAnswer((_) async => const Right(<Movie>[]));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(TopRatedMoviesEvent()),
    expect: () => [
      TopRatedMoviesLoading(),
      const TopRatedMoviesLoaded(<Movie>[]),
      TopRatedMoviesEmpty(),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedMovies.execute());
    },
  );
}
