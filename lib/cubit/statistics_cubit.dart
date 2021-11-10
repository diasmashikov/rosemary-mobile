import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/statistics/statistics.dart';
import 'package:rosemary/data/repository.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final Repository repository;
  StatisticsCubit(this.repository) : super(StatisticsInitial());

  void fetchStatistics({String? token}) {
    repository.getStatistics(token: token).then((statistics) {
      emit(StatisticsLoaded(statistics: statistics));
    });
  }
}
