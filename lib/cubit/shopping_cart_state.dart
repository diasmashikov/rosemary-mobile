part of 'shopping_cart_cubit.dart';

@immutable
abstract class ShoppingCartState {}

class ShoppingCartInitial extends ShoppingCartState {}

class ShoppingCartLoaded extends ShoppingCartState {
  final Order? shoppingCartItems;

  ShoppingCartLoaded({required this.shoppingCartItems});
}
