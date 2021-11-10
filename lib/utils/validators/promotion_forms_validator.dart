import 'package:flutter/material.dart';
import 'package:rosemary/utils/validators/form_validator.dart';

class PromotionFormsValidator extends FormValidator {

  String? validateActivePeriod(value) {
    if (value.isNotEmpty) {
      print("is not empty");
      if (value.contains("-") == false) {
        return "Не соблюден формат";
      } else {
         print("is null");
        return null;
      }
    } else {
      return "Заполните поле";
    }
  }
}
