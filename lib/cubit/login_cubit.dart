import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/login.dart';
import 'package:rosemary/data/repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Repository repository;

  LoginCubit({required this.repository}) : super(LoginInitial());

  Future<Login?> postLogin(email, password) async {
    return repository.postLogin(email, password);
  }
}
