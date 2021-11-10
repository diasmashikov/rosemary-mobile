import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/utils/decorators/TextFieldFormDecorator.dart';
import 'package:rosemary/utils/validators/promotion_forms_validator.dart';
import 'package:sizer/sizer.dart';

class CustomTextFieldForm {
  Widget buildTextFormField<T>(
      {required String formName,
      required String hint,
      required TextEditingController controller,
      required String? Function(String?) validator,
      bool isInputEnabled = true,
      String savedContent = "",
      bool obscure = false}) {
    controller.text = savedContent;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldFormComponents().buildTextFieldFormName(formName: formName),
          SizedBox(
            height: 1.h,
          ),
          TextFormField(
            minLines: 1,
            maxLines: (obscure) ? 1 : 50,
            obscureText: obscure,

            enabled: isInputEnabled,
            controller: controller,
            cursorColor: PRIMARY_DARK_COLOR,
            enableSuggestions: false,
            validator: validator,
            decoration: TextFieldFormComponents()
                .buildTextFieldFormDecorator(formName: formName, hint: hint),
            //obscureText: true,
          ),
        ],
      ),
    );
  }

  Widget buildPhoneTextFormField<T>(
      {required String formName,
      required String hint,
      required TextEditingController controllerBody,
      required TextEditingController controllerPrefix,
      required String? Function(String?) validator,
      bool isInputEnabled = true,
      String savedContent = "",
      bool obscure = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldFormComponents().buildTextFieldFormName(formName: formName),
          SizedBox(
            height: 1.h,
          ),
          
         TextFormField(
                    minLines: 1,
                    maxLines: (obscure) ? 1 : 50,
                    obscureText: obscure,
                    enabled: isInputEnabled,
                    controller: controllerPrefix,
                    cursorColor: PRIMARY_DARK_COLOR,
                    enableSuggestions: false,
                    validator: validator,
                    decoration: TextFieldFormComponents()
                        .buildTextFieldFormDecorator(formName: formName, hint: hint),
                    //obscureText: true,
                  ),
        ],
      ),
    );

    
  }
}
