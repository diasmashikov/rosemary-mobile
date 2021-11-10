import 'package:flutter/material.dart';
import 'package:rosemary/utils/validators/form_validator.dart';

class RegistrationFormsValidator extends FormValidator {

  String? validateEmail(value) {
    if (value.isNotEmpty) {
      print("is not empty");
      if (value.contains("@") == false) {
        return "Не соблюден формат";
      } else {
         print("is null");
        return null;
      }
    } else {
      return "Заполните поле";
    }
  }

  String? validatePassword(value) {
    if (value.isNotEmpty) {
      print("is not empty");
      if (value.length < 8) {
        return "Пароль должен быть минимум 8 символов";
      } else {
         print("is null");
        return null;
      }
    } else {
      return "Заполните поле";
    }
  }
}
