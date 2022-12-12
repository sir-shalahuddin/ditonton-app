// ignore_for_file: constant_identifier_names

import 'package:core/core.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../bloc/watchlist_movie/watchlist_movie_bloc.dart';
import '../bloc/watchlist_tv/watchlist_tv_bloc.dart';


class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<WatchlistMovieBloc>(context, listen: false)
            .add(WatchlistMovieEvent()),);
    Future.microtask(() =>
        Provider.of<WatchlistTvBloc>(context, listen: false)
            .add(WatchlistTvEvent()),);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieBloc>(context, listen: false)
        .add(WatchlistMovieEvent());
    Provider.of<WatchlistTvBloc>(context, listen: false)
        .add(WatchlistTvEvent());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Expanded(
              child: TabBarView(
                children: [MovieWatchList(), TvWatchList()],
              ),
            ),
            TabBar(
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(50), // Creates border
                color: Colors.white54,
              ),
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
              splashBorderRadius: const BorderRadius.all(Radius.circular(15)),
              tabs: const [
                Tab(
                  child: Icon(Icons.movie),
                ),
                Tab(
                  child: Icon(Icons.tv),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}

class MovieWatchList extends StatelessWidget {
  const MovieWatchList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistMovieHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final movie = state.watchlistMovieResult[index];
                return MovieCard(movie);
              },
              itemCount: state.watchlistMovieResult.length,
            );
          } else if(state is WatchlistMovieEmpty) {
            return Center(
              child: Text(state.message),
            );
          }
          else if(state is WatchlistMovieError) {
            return Center(
              child: Text(state.message),
            );
          }
          else {
            return Container();
          }
        },
      ),
    );
  }
}

class TvWatchList extends StatelessWidget {
  const TvWatchList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<WatchlistTvBloc,WatchlistTvState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WatchlistHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tv = state.watchlistResult[index];
                return TvCard(tv);
              },
              itemCount: state.watchlistResult.length,
            );
          } else if(state is WatchlistEmpty) {
            return Center(
              child: Text(state.message),
            );
          }
          else if(state is WatchlistError) {
            return Center(
              child: Text(state.message),
            );
          }
          else {
            return Container();
          }
        },
      ),
    );
  }
}
