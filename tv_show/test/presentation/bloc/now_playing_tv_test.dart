import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_show/presentation/bloc/now_playing_tvs/now_playing_tvs_bloc.dart';

import 'now_playing_tv_test.mocks.dart';



@GenerateMocks([GetNowPlayingTvs])
void main() {
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late NowPlayingTvsBloc nowPlayingTvsBloc;

  setUp(() {
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    nowPlayingTvsBloc = NowPlayingTvsBloc(mockGetNowPlayingTvs);
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

  test('Initial state should be empty', () {
    expect(nowPlayingTvsBloc.state, NowPlayingTvsEmpty());
  });

  blocTest(
      'should emit [NowPlayingTvsLoaded, NowPlayingTvsLoading] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return nowPlayingTvsBloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvsEvent()),
      expect: () =>
      [
        NowPlayingTvsLoading(),
        NowPlayingTvsLoaded(tTvList)
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
      }
  );

  blocTest(
      'should emit [NowPlayingTvsLoaded, NowPlayingTvsLoading] when error',
      build: () {
        when(mockGetNowPlayingTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return nowPlayingTvsBloc;
      },
      act: (bloc) => bloc.add(NowPlayingTvsEvent()),
      expect: () =>
      [
        NowPlayingTvsLoading(),
        const NowPlayingTvsError('Failed')
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTvs.execute());
      }
  );

  blocTest<NowPlayingTvsBloc, NowPlayingTvState> (
    'Should emit [NowPlayingTvsLoading, NowPlayingTvsLoaded[], NowPlayingTvsEmpty] when data is gotten successfully',
    build: () {
      when(mockGetNowPlayingTvs.execute())
          .thenAnswer((_) async => const Right(<Tv>[]));
      return nowPlayingTvsBloc;
    },
    act: (bloc) => bloc.add(NowPlayingTvsEvent()),
    expect: () => [
      NowPlayingTvsLoading(),
      const NowPlayingTvsLoaded(<Tv>[]),
      NowPlayingTvsEmpty(),
    ],
    verify: (bloc) {
      verify(mockGetNowPlayingTvs.execute());
    },
  );
}
