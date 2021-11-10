part of 'crud_orders_cubit.dart';

@immutable
abstract class CrudOrdersState {}

class CrudOrdersInitial extends CrudOrdersState {}

class CrudOrdersLoaded extends CrudOrdersState {
  final OrdersInProgress? ordersInProgress;

  CrudOrdersLoaded({required this.ordersInProgress});
}

