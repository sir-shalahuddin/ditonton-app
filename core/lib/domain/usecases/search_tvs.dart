import 'package:dartz/dartz.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import '../../domain/repositories/tv_repository.dart';

class SearchTvs {
  final TvRepository repository;

  SearchTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
