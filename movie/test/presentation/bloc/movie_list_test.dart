import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';

import 'movie_list_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late NowPlayingMovieListBloc nowPlayingMovieListBloc;
  late PopularMovieListBloc popularMovieListBloc;
  late TopRatedMovieListBloc topRatedMovieListBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    nowPlayingMovieListBloc = NowPlayingMovieListBloc(mockGetNowPlayingMovies);
    popularMovieListBloc = PopularMovieListBloc(mockGetPopularMovies);
    topRatedMovieListBloc = TopRatedMovieListBloc(mockGetTopRatedMovies);
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

  group(
    'now playing movies',
    () {
      test('initialState should be Empty', () {
        expect(nowPlayingMovieListBloc.state, MovieListEmpty());
      });

      blocTest(
        'should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return nowPlayingMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        },
      );

      blocTest(
        'should emit [MovieListLoading, MovieListError] when error',
        build: () {
          when(mockGetNowPlayingMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return nowPlayingMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), const MovieListError('Failed')],
        verify: (bloc) {
          verify(mockGetNowPlayingMovies.execute());
        },
      );
    },
  );

  group(
    'popular movies',
        () {
      test('initialState should be Empty', () {
        expect(popularMovieListBloc.state, MovieListEmpty());
      });

      blocTest(
        'should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return popularMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );

      blocTest(
        'should emit [MovieListLoading, MovieListError] when error',
        build: () {
          when(mockGetPopularMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return popularMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), const MovieListError('Failed')],
        verify: (bloc) {
          verify(mockGetPopularMovies.execute());
        },
      );
    },
  );

  group(
    'top rated movies',
        () {
      test('initialState should be Empty', () {
        expect(topRatedMovieListBloc.state, MovieListEmpty());
      });

      blocTest(
        'should emit [MovieListLoading, MovieListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Right(tMovieList));
          return topRatedMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), MovieListLoaded(tMovieList)],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        },
      );

      blocTest(
        'should emit [MovieListLoading, MovieListError] when error',
        build: () {
          when(mockGetTopRatedMovies.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return topRatedMovieListBloc;
        },
        act: (bloc) => bloc.add(MovieListEvent()),
        expect: () => [MovieListLoading(), const MovieListError('Failed')],
        verify: (bloc) {
          verify(mockGetTopRatedMovies.execute());
        },
      );
    },
  );
}
