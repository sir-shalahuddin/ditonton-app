import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_movie.dart';
import 'package:watchlist/domain/usecases/save_watchlist_movie.dart';
import 'package:watchlist/watchlist.dart';


import 'movie_detail_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListMovieStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListMovieStatus mockGetWatchListMovieStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListMovieStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    movieDetailBloc = MovieDetailBloc(
        getMovieDetail: mockGetMovieDetail,
        getMovieRecommendations: mockGetMovieRecommendations,
        getWatchListStatus: mockGetWatchListMovieStatus,
        saveWatchlist: mockSaveWatchlistMovie,
        removeWatchlist: mockRemoveWatchlistMovie);
  });

  const testId = 1;
  final movieDetailStateInit = MovieDetailState.initial();
  final testMovie = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: const [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final testMovies = <Movie>[testMovie];

  final testMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group("Get Movie Detail", () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      "Should emit MovieDetailLoading, RecommendationLoading, MovieDetailLoaded and RecommendationLoaded when get  Detail Movies and Recommendation Success",
      build: () {
        when(mockGetMovieDetail.execute(testId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(testId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.Loading,
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.Loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.Loaded,
          movieRecommendations: testMovies,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(testId));
        verify(mockGetMovieRecommendations.execute(testId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      "Should emit MovieDetailLoading, RecommendationLoading, MovieDetailLoaded and RecommendationError when get MoviesRecommendation Error",
      build: () {
        when(mockGetMovieDetail.execute(testId))
            .thenAnswer((_) async => Right(testMovieDetail));
        when(mockGetMovieRecommendations.execute(testId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(testId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.Loading,
          movieDetail: testMovieDetail,
          movieDetailState: RequestState.Loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.Loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(testId));
        verify(mockGetMovieRecommendations.execute(testId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      "Should emit MovieDetailError when Get Movie Detail Failed",
      build: () {
        when(mockGetMovieDetail.execute(testId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetMovieRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(testId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.Loading),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(testId));
        verify(mockGetMovieRecommendations.execute(testId));
      },
    );
  });

  group("Add to Watchlist Movie", () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        movieDetailStateInit.copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit watchlistMessage when Failed',
      build: () {
        when(mockSaveWatchlistMovie.execute(testMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistMovie.execute(testMovieDetail));
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Movie', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
        'Should emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
        build: () {
          when(mockRemoveWatchlistMovie.execute(testMovieDetail))
              .thenAnswer((_) async => const Right('Removed From Watchlist'));
          when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
              .thenAnswer((_) async => false);
          return movieDetailBloc;
        },
        act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
        expect: () => [
              movieDetailStateInit.copyWith(
                  watchlistMessage: 'Removed From Watchlist',
                  isAddedToWatchlist: false),
            ],
        verify: (_) {
          verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
          verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
        });
  });

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Should emit watchlistMessage when Failed',
    build: () {
      when(mockRemoveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListMovieStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
    expect: () => [
      movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
    },
  );

  group('LoadWatchlistStatus', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should Emit AddWatchlistStatus True',
      build: () {
        when(mockGetWatchListMovieStatus.execute(testId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(testId)),
      expect: () => [
        movieDetailStateInit.copyWith(
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetWatchListMovieStatus.execute(testMovieDetail.id));
      },
    );
  });
}
