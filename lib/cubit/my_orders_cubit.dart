import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/myOrders.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'my_orders_state.dart';

class MyOrdersCubit extends Cubit<MyOrdersState> {
  final Repository repository;
  MyOrdersCubit({required this.repository}) : super(MyOrdersInitial());


  void fetchMyOrders({String? token, User? userData}) {
    repository.getMyOrders(token: token, userData: userData).then((myOrders) {
      emit(MyOrdersLoaded(myOrders: myOrders));
    });
  }
}
