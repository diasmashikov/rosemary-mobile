import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  

  final Repository repository;

  PlaceOrderCubit({required this.repository})
      : super(PlaceOrderInitial());

  Future<void> updateOrder(
      {String? token, User? userData, required String status, required Order cartOrder}) async {
    repository.putOrderPending(token: token, userData: userData, status: status, cartOrder: cartOrder);
  }
}
