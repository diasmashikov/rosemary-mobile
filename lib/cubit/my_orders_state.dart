part of 'my_orders_cubit.dart';

@immutable
abstract class MyOrdersState {}

class MyOrdersInitial extends MyOrdersState {}

class MyOrdersLoaded extends MyOrdersState {
  final MyOrders myOrders;

  MyOrdersLoaded({required this.myOrders});
}
