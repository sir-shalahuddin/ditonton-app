import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_show/domain/usecases/get_popular_tv.dart';
import 'package:tv_show/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';

import 'popular_tv_test.mocks.dart';


@GenerateMocks([GetPopularTvs])
void main() {
  late MockGetPopularTvs mockGetPopularTvs;
  late PopularTvsBloc popularTvsBloc;

  setUp(() {
    mockGetPopularTvs = MockGetPopularTvs();
    popularTvsBloc = PopularTvsBloc(mockGetPopularTvs);
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
    expect(popularTvsBloc.state, PopularTvsEmpty());
  });

  blocTest(
      'should emit [PopularTvsLoaded, PopularTvsLoading] when data is gotten successfully',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Right(tTvList));
        return popularTvsBloc;
      },
      act: (bloc) => bloc.add(PopularTvsEvent()),
      expect: () =>
      [
        PopularTvsLoading(),
        PopularTvsLoaded(tTvList)
      ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      }
  );

  blocTest(
      'should emit [PopularTvsLoaded, PopularTvsLoading] when error',
      build: () {
        when(mockGetPopularTvs.execute())
            .thenAnswer((_) async => Left(ServerFailure('Failed')));
        return popularTvsBloc;
      },
      act: (bloc) => bloc.add(PopularTvsEvent()),
      expect: () =>
      [
        PopularTvsLoading(),
        const PopularTvsError('Failed')
      ],
      verify: (bloc) {
        verify(mockGetPopularTvs.execute());
      }
  );

  blocTest<PopularTvsBloc, PopularTvsState> (
    'Should emit [PopularTvsLoading, PopularTvsLoaded[], PopularTvsEmpty] when data is gotten successfully',
    build: () {
      when(mockGetPopularTvs.execute())
          .thenAnswer((_) async => const Right(<Tv>[]));
      return popularTvsBloc;
    },
    act: (bloc) => bloc.add(PopularTvsEvent()),
    expect: () => [
      PopularTvsLoading(),
      const PopularTvsLoaded(<Tv>[]),
      PopularTvsEmpty(),
    ],
    verify: (bloc) {
      verify(mockGetPopularTvs.execute());
    },
  );
}
