import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_show/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';

import 'top_rated_tv_test.mocks.dart';


@GenerateMocks([GetTopRatedTvs])
void main() {
  late MockGetTopRatedTvs mockGetTopRatedTvs;
  late TopRatedTvsBloc topRatedTvsBloc;

  setUp(() {
    mockGetTopRatedTvs = MockGetTopRatedTvs();
    topRatedTvsBloc = TopRatedTvsBloc(mockGetTopRatedTvs);
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
    expect(topRatedTvsBloc.state, TopRatedTvsEmpty());
  });

  blocTest(
      'should emit [TopRatedTvsLoaded, TopRatedTvsLoading] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return topRatedTvsBloc;
      },
      act: (bloc) => bloc.add(TopRatedTvsEvent()),
      expect: () =>
      [
        TopRatedTvsLoading(),
        TopRatedTvsLoaded(tTvList)
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      }
  );

  blocTest(
      'should emit [TopRatedTvsLoaded, TopRatedTvsLoading] when error',
      build: () {
        when(mockGetTopRatedTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return topRatedTvsBloc;
      },
      act: (bloc) => bloc.add(TopRatedTvsEvent()),
      expect: () =>
      [
        TopRatedTvsLoading(),
        const TopRatedTvsError('Failed')
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTvs.execute());
      }
  );

  blocTest<TopRatedTvsBloc, TopRatedTvsState> (
    'Should emit [TopRatedTvsLoading, TopRatedTvsLoaded[], TopRatedTvsEmpty] when data is gotten successfully',
    build: () {
      when(mockGetTopRatedTvs.execute())
          .thenAnswer((_) async => const Right(<Tv>[]));
      return topRatedTvsBloc;
    },
    act: (bloc) => bloc.add(TopRatedTvsEvent()),
    expect: () => [
      TopRatedTvsLoading(),
      const TopRatedTvsLoaded(<Tv>[]),
      TopRatedTvsEmpty(),
    ],
    verify: (bloc) {
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
