import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'info_state.dart';

class InfoCubit extends Cubit<InfoState> {
  final Repository repository;
  InfoCubit({required this.repository}) : super(InfoInitial());

  Future<void>? putInfo(
      {required String email,
      required String firstName,
      required String lastName,
      required String phone, token, User? user}) {
    repository.putInfo(
        email: email, firstName: firstName, lastName: lastName, phone: phone, user: user, token: token);
  }
}
