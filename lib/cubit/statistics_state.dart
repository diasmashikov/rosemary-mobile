part of 'statistics_cubit.dart';

@immutable
abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Statistics? statistics;

  StatisticsLoaded({required this.statistics});
}
