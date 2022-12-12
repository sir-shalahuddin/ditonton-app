import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:movie/movie.dart';
import 'package:movie/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/bloc/movie_list/movie_list_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie/popular_movies_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:search/presentation/bloc/movie_search_bloc.dart';
import 'package:search/presentation/bloc/tv_search_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:tv_show/domain/usecases/get_now_playing_tv.dart';
import 'package:tv_show/domain/usecases/get_popular_tv.dart';
import 'package:tv_show/domain/usecases/get_top_rated_tv.dart';
import 'package:tv_show/domain/usecases/get_tv_detail.dart';
import 'package:tv_show/domain/usecases/get_tv_recommendations.dart';
import 'package:tv_show/presentation/bloc/now_playing_tvs/now_playing_tvs_bloc.dart';
import 'package:tv_show/presentation/bloc/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv_show/presentation/bloc/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv_show/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:tv_show/presentation/bloc/tv_list/tv_list_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:watchlist/watchlist.dart';

final locator = GetIt.instance;

void init() {

  //provider
  locator.registerFactory(() => NowPlayingMovieListBloc(
    locator(),
  ));
  locator.registerFactory(() => TopRatedMovieListBloc(
    locator(),
  ));
  locator.registerFactory(() => PopularMovieListBloc(
    locator(),
  ));
  locator.registerFactory(
        () => MovieDetailBloc(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchBloc(
    locator(),
  ));
  locator.registerFactory(
        () => PopularMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TopRatedMoviesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistMovieBloc(
      locator(),
    ),
  );
  locator.registerFactory(() => NowPlayingTvListBloc(
    locator(),
  ));
  locator.registerFactory(() => TopRatedTvListBloc(
    locator(),
  ));
  locator.registerFactory(() => PopularTvListBloc(
    locator(),
  ));
  locator.registerFactory(
        () => TvDetailBloc(
      getTvDetail: locator(),
      getTvRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => TvSearchBloc(
    locator(),
  ));
  locator.registerFactory(
        () => NowPlayingTvsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => PopularTvsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => TopRatedTvsBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistTvBloc(
      locator(),
    ),
  );

  // use case movie
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListMovieStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  // use case tv series
  locator.registerLazySingleton(() => GetNowPlayingTvs(locator()));
  locator.registerLazySingleton(() => GetPopularTvs(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvs(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => SearchTvs(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvs(locator()));
  locator.registerLazySingleton(() => GetWatchListTvStatus(locator()));

  // repository movie
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // repository tv series
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources movie
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // data sources tv
  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());

  // external
  locator.registerLazySingleton(() => http.Client());
}
