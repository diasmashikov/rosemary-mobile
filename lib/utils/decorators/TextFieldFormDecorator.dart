import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:sizer/sizer.dart';

class TextFieldFormComponents {
  Text buildTextFieldFormName({required String formName}) {
    return Text(formName,
        style: TextStyle(
            color: Color.fromRGBO(58, 67, 59, 1),
            fontFamily: 'Merriweather-Regular',
            fontSize: 11.sp));
  }

  InputDecoration buildTextFieldFormDecorator({required String formName, required String hint}) {
    return InputDecoration(
      
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: PRIMARY_DARK_COLOR, width: 0.2.w),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: PRIMARY_DARK_COLOR)),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintText: hint,
        labelText: hint);
  }
}
