import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/repository.dart';

part 'shopping_cart_state.dart';

class ShoppingCartCubit extends Cubit<ShoppingCartState> {
  final Repository repository;

  ShoppingCartCubit({required this.repository}) : super(ShoppingCartInitial());

  void fetchShoppingCartItems(
      {required String? token, required String userId}) {
    repository.getShoppingCartItems(token, userId).then((shoppingCartItems) {
      print("SCART CUBIT");
      print(shoppingCartItems);
     
      emit(ShoppingCartLoaded(shoppingCartItems: shoppingCartItems));
    });
  }

  Future<void> deleteShoppingCartItem(
      {String? token,
      required String userId,
      required Order shoppingCartOrder,
      required int index,
      required String orderItemId, required int changedTotalPrice}) async {
    repository.deleteShoppingCartItem(
        token, userId, shoppingCartOrder, index, orderItemId, changedTotalPrice);
  }
}
