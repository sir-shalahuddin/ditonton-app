import 'package:dartz/dartz.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import '../../domain/repositories/tv_repository.dart';

class GetTvRecommendations {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  Future<Either<Failure, List<Tv>>> execute(id) {
    return repository.getTvRecommendations(id);
  }
}
