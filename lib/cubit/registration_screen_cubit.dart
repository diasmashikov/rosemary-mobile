import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/repository.dart';

part 'registration_screen_state.dart';

class RegistrationScreenCubit extends Cubit<RegistrationScreenState> {
  final Repository repository;

  RegistrationScreenCubit({required this.repository}) : super(RegistrationScreenInitial());

  Future<void> registerUser(
      {required String email, required String firstName, required String lastName, required String phoneNumber, required String phoneNumberPrefix, required String password}) async {
    repository.postUser(email: email, firstName: firstName, lastName: lastName, phoneNumberPrefix: phoneNumberPrefix, phoneNumber: phoneNumber, password: password);
      
  }
}
