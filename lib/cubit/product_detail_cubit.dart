import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/cubit/products_cubit.dart';
import 'package:rosemary/data/models/favorite.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final Repository repository;

  ProductDetailCubit({required this.repository})
      : super(ProductDetailInitial());

  Future<void> postOrderCart(
      {required Product product,
      String? token,
      User? user,
      required int quantity,
      required String? pickedSize}) async {
    repository.postOrderCart(
        product: product,
        token: token,
        user: user,
        quantity: quantity,
        pickedSize: pickedSize);
  }

  void fetchCartOrder({required String status, String? token, User? user}) {
    repository
        .getCartOrder(status: status, token: token, user: user)
        .then((cartOrder) {
      emit(ProductDetailLoaded(cartOrder: cartOrder));
    });
  }

  Future<void> putOrderCart(
      {required Order cartOrder, String? token, User? user, required Product product, required String quantity, required String? size}) async {
    repository.putOrderCart(
        token: token, cartOrder: cartOrder, user: user, product: product, quantity: quantity, size: size);
  }
}
