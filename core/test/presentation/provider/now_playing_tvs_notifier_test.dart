import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_now_playing_tv.dart';
import 'package:core/presentation/provider/now_playing_tvs_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'now_playing_tvs_notifier_test.mocks.dart';



@GenerateMocks([GetNowPlayingTvs])
void main() {
  late MockGetNowPlayingTvs mockGetNowPlayingTvs;
  late NowPlayingTvsNotifier notifier;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetNowPlayingTvs = MockGetNowPlayingTvs();
    notifier = NowPlayingTvsNotifier(getNowPlayingTvs: mockGetNowPlayingTvs)
      ..addListener(() {
        listenerCallCount++;
      });
  });

  final tTv = Tv(
    backdropPath: '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
    firstAirDate: "2002-12-14",
    genreIds: [16, 35],
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

  test('should change state to loading when usecase is called', () async {
    // arrange
    when(mockGetNowPlayingTvs.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    notifier.fetchNowPlayingTvs();
    // assert
    expect(notifier.state, RequestState.Loading);
    expect(listenerCallCount, 1);
  });

  test('should change Tvs data when data is gotten successfully', () async {
    // arrange
    when(mockGetNowPlayingTvs.execute())
        .thenAnswer((_) async => Right(tTvList));
    // act
    await notifier.fetchNowPlayingTvs();
    // assert
    expect(notifier.state, RequestState.Loaded);
    expect(notifier.tvs, tTvList);
    expect(listenerCallCount, 2);
  });

  test('should return error when data is unsuccessful', () async {
    // arrange
    when(mockGetNowPlayingTvs.execute())
        .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
    // act
    await notifier.fetchNowPlayingTvs();
    // assert
    expect(notifier.state, RequestState.Error);
    expect(notifier.message, 'Server Failure');
    expect(listenerCallCount, 2);
  });
}
