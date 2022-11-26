import 'package:dartz/dartz.dart';
import '../../core.dart';
import '../../domain/entities/tv.dart';
import '../../domain/repositories/tv_repository.dart';

class GetTopRatedTvs {
  final TvRepository repository;

  GetTopRatedTvs(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTvs();
  }
}
