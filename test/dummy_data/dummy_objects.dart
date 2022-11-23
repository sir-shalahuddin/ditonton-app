import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
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

final testMovieList = [testMovie];

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

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTv = Tv(
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

final testTvList = [testTv];

final testTvDetail = TvDetail(
  backdropPath: '/w0eG4lpAigocIZzJYrYp3cCmyUx.jpg',
  firstAirDate: "2002-12-14",
  genres : [Genre(id: 16, name: "Animation"),Genre(id: 35, name: "Comedy")],
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

final testWatchlistTv = Tv.watchlist(
  id: 2,
  name: 'The Last Episode Ever',
  posterPath: '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
  overview:  "The guys' day slacking off at the Quick Stop is derailed by a spoof of \"The Matrix,\" a carnival riot and a trip through the minds of their illustrators.",
);

final testTvTable = TvTable(
  id: 2,
  name: 'The Last Episode Ever',
  posterPath: '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
  overview:  "The guys' day slacking off at the Quick Stop is derailed by a spoof of \"The Matrix,\" a carnival riot and a trip through the minds of their illustrators.",
);

final testTvMap = {
  "id": 2,
  "name": 'The Last Episode Ever',
  "posterPath": '/xunXvzFlkf1GGgMkCySA9CCFumB.jpg',
  "overview":  "The guys' day slacking off at the Quick Stop is derailed by a spoof of \"The Matrix,\" a carnival riot and a trip through the minds of their illustrators.",
};
