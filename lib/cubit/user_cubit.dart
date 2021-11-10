import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final Repository repository;

  UserCubit({required this.repository}) : super(UserInitial());

  void fetchUserData({required String? token, required String userId}) {
    repository.getUserData(token, userId).then((userData) {
      emit(UserLoaded(userData: userData));
    });
  }
}