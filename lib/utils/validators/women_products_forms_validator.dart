import 'package:flutter/material.dart';
import 'package:rosemary/utils/validators/form_validator.dart';

class WomenProductsFormsValidator extends FormValidator {
  String? validateSizes(value) {
    if (value.isNotEmpty) {
      print("is not empty");
      var values = value.split('/');
      if (values.length != 1) {
        if (value.contains("/") == false) {
          return "Не соблюден формат";
        } else {
          print("is null");
          return null;
        }
      } else {
        return null;
      }
    } else {
      return "Заполните поле";
    }
  }

  String? validateModelCharacteristics(value) {
    if (value.isNotEmpty) {
      print("is not empty");
      if (value.contains("\n") == true) {
        return null;
      } else {
        return "Формат не соблюден";
      }
    } else {
      return "Заполните поле";
    }
  }
}
