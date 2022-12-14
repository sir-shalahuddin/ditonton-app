import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_tv_detail.dart';
import 'package:tv_show/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:watchlist/domain/usecases/get_watchlist_tv_status.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_tv.dart';
import 'package:watchlist/domain/usecases/save_watchlist_tv.dart';


import 'tv_detail_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListTvStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListTvStatus mockGetWatchListTvStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListTvStatus = MockGetWatchListTvStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(
        getTvDetail: mockGetTvDetail,
        getTvRecommendations: mockGetTvRecommendations,
        getWatchListStatus: mockGetWatchListTvStatus,
        saveWatchlist: mockSaveWatchlistTv,
        removeWatchlist: mockRemoveWatchlistTv);
  });

  const testId = 2;
  final tvDetailStateInit = TvDetailState.initial();
  final testTv = Tv(
    backdropPath: '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
    firstAirDate: "2002-12-14",
    genreIds: const [16, 35],
    id: 2,
    name: 'The Last Episode Ever',
    originalLanguage: "en",
    originalName: "Clerks: The Animated Series",
    overview:
        "The guys' day slacking off at the Quick Stop is derailed by a spoof of \"The Matrix,\" a carnival riot and a trip through the minds of their illustrators.",
    popularity: 8.636,
    posterPath: '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
    voteAverage: 6.903,
    voteCount: 72,
  );

  final testTvs = <Tv>[testTv];

  final testTvDetail = TvDetail(
    backdropPath: '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
    firstAirDate: "2002-12-14",
    genres: [Genre(id: 16, name: "Animation"), Genre(id: 35, name: "Comedy")],
    id: 2,
    name: 'The Last Episode Ever',
    originalName: "Clerks: The Animated Series",
    overview:
        "The guys' day slacking off at the Quick Stop is derailed by a spoof of \"The Matrix,\" a carnival riot and a trip through the minds of their illustrators.",
    posterPath: '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
    tagline: "",
    voteAverage: 6.903,
    voteCount: 72,
  );

  group("Get Tv Detail", () {
    blocTest<TvDetailBloc, TvDetailState>(
      "Should emit TvDetailLoading, RecommendationLoading, TvDetailLoaded and RecommendationLoaded when get  Detail Tvs and Recommendation Success",
      build: () {
        when(mockGetTvDetail.execute(testId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testTvs));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(testId)),
      expect: () => [
        tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        tvDetailStateInit.copyWith(
          tvRecommendationState: RequestState.Loading,
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          message: '',
        ),
        tvDetailStateInit.copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: testTvDetail,
          tvRecommendationState: RequestState.Loaded,
          tvRecommendations: testTvs,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(testId));
        verify(mockGetTvRecommendations.execute(testId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      "Should emit TvDetailLoading, RecommendationLoading, TvDetailLoaded and RecommendationError when get TvsRecommendation Error",
      build: () {
        when(mockGetTvDetail.execute(testId))
            .thenAnswer((_) async => Right(testTvDetail));
        when(mockGetTvRecommendations.execute(testId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(testId)),
      expect: () => [
        tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        tvDetailStateInit.copyWith(
          tvRecommendationState: RequestState.Loading,
          tvDetail: testTvDetail,
          tvDetailState: RequestState.Loaded,
          message: '',
        ),
        tvDetailStateInit.copyWith(
          tvDetailState: RequestState.Loaded,
          tvDetail: testTvDetail,
          tvRecommendationState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(testId));
        verify(mockGetTvRecommendations.execute(testId));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      "Should emit TvDetailError when Get Tv Detail Failed",
      build: () {
        when(mockGetTvDetail.execute(testId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        when(mockGetTvRecommendations.execute(testId))
            .thenAnswer((_) async => Right(testTvs));
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const FetchTvDetail(testId)),
      expect: () => [
        tvDetailStateInit.copyWith(tvDetailState: RequestState.Loading),
        tvDetailStateInit.copyWith(
          tvDetailState: RequestState.Error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetTvDetail.execute(testId));
        verify(mockGetTvRecommendations.execute(testId));
      },
    );
  });

  group("Add to Watchlist Tv", () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchListTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        tvDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        tvDetailStateInit.copyWith(
          watchlistMessage: 'Added to Watchlist',
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
      },
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'Should emit watchlistMessage when Failed',
      build: () {
        when(mockSaveWatchlistTv.execute(testTvDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchListTvStatus.execute(testTvDetail.id))
            .thenAnswer((_) async => false);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
      expect: () => [
        tvDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlistTv.execute(testTvDetail));
        verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Tv', () {
    blocTest<TvDetailBloc, TvDetailState>(
        'Should emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
        build: () {
          when(mockRemoveWatchlistTv.execute(testTvDetail))
              .thenAnswer((_) async => const Right('Removed From Watchlist'));
          when(mockGetWatchListTvStatus.execute(testTvDetail.id))
              .thenAnswer((_) async => false);
          return tvDetailBloc;
        },
        act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
        expect: () => [
              tvDetailStateInit.copyWith(
                  watchlistMessage: 'Removed From Watchlist',
                  isAddedToWatchlist: false),
            ],
        verify: (_) {
          verify(mockRemoveWatchlistTv.execute(testTvDetail));
          verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
        });
  });

  blocTest<TvDetailBloc, TvDetailState>(
    'Should emit watchlistMessage when Failed',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListTvStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
    expect: () => [
      tvDetailStateInit.copyWith(watchlistMessage: 'Failed'),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
    },
  );

  group('LoadWatchlistStatus', () {
    blocTest<TvDetailBloc, TvDetailState>(
      'Should Emit AddWatchlistStatus True',
      build: () {
        when(mockGetWatchListTvStatus.execute(testId))
            .thenAnswer((_) async => true);
        return tvDetailBloc;
      },
      act: (bloc) => bloc.add(const LoadWatchlistStatus(testId)),
      expect: () => [
        tvDetailStateInit.copyWith(
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetWatchListTvStatus.execute(testTvDetail.id));
      },
    );
  });
}
