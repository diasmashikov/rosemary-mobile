import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/order.dart';
import 'package:rosemary/data/models/ordersInProgress.dart';
import 'package:rosemary/data/repository.dart';
import 'package:timezone/src/date_time.dart';

part 'crud_orders_state.dart';

class CrudOrdersCubit extends Cubit<CrudOrdersState> {
  final Repository repository;
  CrudOrdersCubit({required this.repository}) : super(CrudOrdersInitial());

  void fetchOrdersInProgress({String? token, required TZDateTime dateAndTime}) {
    repository.getOrdersInProgress(token: token, dateAndTime: dateAndTime).then((ordersInProgress) {
      emit(CrudOrdersLoaded(ordersInProgress: ordersInProgress));
    });
  }

  Future<void> updateOrderStatus(
      String token, String orderId, String chosenStatus) async {
    repository.putOrderStatus(token, orderId, chosenStatus);
  }
}
