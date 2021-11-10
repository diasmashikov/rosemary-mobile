part of 'promotions_cubit.dart';

@immutable
abstract class PromotionsState {}

class PromotionsInitial extends PromotionsState {}

class PromotionsLoaded extends PromotionsState {
  final List<Promotion>? promotions;

  PromotionsLoaded({required this.promotions});
}



