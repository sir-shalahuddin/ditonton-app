import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_show/domain/usecases/get_popular_tv.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';

import 'tv_list_test.mocks.dart';


@GenerateMocks([GetNowPlayingTvs, GetPopularTvs, GetTopRatedTvs])
void main() {
  late NowPlayingTvListBloc nowPlayingTvListBloc;
  late PopularTvListBloc popularTvListBloc;
  late TopRatedTvListBloc topRatedTvListBloc;
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late MockGetPopularTvs mockGetPopularTvs;
  late MockGetTopRatedTvs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    mockGetPopularTvs = MockGetPopularTvs();
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    nowPlayingTvListBloc = NowPlayingTvListBloc(mockGetNowPlayingTvs);
    popularTvListBloc = PopularTvListBloc(mockGetPopularTvs);
    topRatedTvListBloc = TopRatedTvListBloc(mockGetTopRatedTvs);
  });

  final tTv = Tv(
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
  final tTvList = <Tv>[tTv];

  group(
    'now playing Tvs',
    () {
      test('initialState should be Empty', () {
        expect(nowPlayingTvListBloc.state, TvListEmpty());
      });

      blocTest(
        'should emit [TvListLoading, TvListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetNowPlayingTvs.execute())
              .thenAnswer((_) async => Right(tTvList));
          return nowPlayingTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), TvListLoaded(tTvList)],
        verify: (bloc) {
          verify(mockGetNowPlayingTvs.execute());
        },
      );

      blocTest(
        'should emit [TvListLoading, TvListError] when error',
        build: () {
          when(mockGetNowPlayingTvs.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return nowPlayingTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), const TvListError('Failed')],
        verify: (bloc) {
          verify(mockGetNowPlayingTvs.execute());
        },
      );
    },
  );

  group(
    'popular Tvs',
        () {
      test('initialState should be Empty', () {
        expect(popularTvListBloc.state, TvListEmpty());
      });

      blocTest(
        'should emit [TvListLoading, TvListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetPopularTvs.execute())
              .thenAnswer((_) async => Right(tTvList));
          return popularTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), TvListLoaded(tTvList)],
        verify: (bloc) {
          verify(mockGetPopularTvs.execute());
        },
      );

      blocTest(
        'should emit [TvListLoading, TvListError] when error',
        build: () {
          when(mockGetPopularTvs.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return popularTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), const TvListError('Failed')],
        verify: (bloc) {
          verify(mockGetPopularTvs.execute());
        },
      );
    },
  );

  group(
    'top rated Tvs',
        () {
      test('initialState should be Empty', () {
        expect(topRatedTvListBloc.state, TvListEmpty());
      });

      blocTest(
        'should emit [TvListLoading, TvListLoaded] when data is gotten successfully',
        build: () {
          when(mockGetTopRatedTvs.execute())
              .thenAnswer((_) async => Right(tTvList));
          return topRatedTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), TvListLoaded(tTvList)],
        verify: (bloc) {
          verify(mockGetTopRatedTvs.execute());
        },
      );

      blocTest(
        'should emit [TvListLoading, TvListError] when error',
        build: () {
          when(mockGetTopRatedTvs.execute())
              .thenAnswer((_) async => Left(ServerFailure('Failed')));
          return topRatedTvListBloc;
        },
        act: (bloc) => bloc.add(TvListEvent()),
        expect: () => [TvListLoading(), const TvListError('Failed')],
        verify: (bloc) {
          verify(mockGetTopRatedTvs.execute());
        },
      );
    },
  );
}
