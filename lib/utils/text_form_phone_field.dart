import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';

class AppTextFormPhoneField extends StatefulWidget {
  String inputTextPrefix;
  String inputText;
  final TextEditingController controllerPrefix;
  final TextEditingController controller;


  AppTextFormPhoneField({required this.controller, required this.inputText, required this.inputTextPrefix, required this.controllerPrefix});

  @override
  _AppTextFormPhoneFieldState createState() => _AppTextFormPhoneFieldState();
}

class _AppTextFormPhoneFieldState extends State<AppTextFormPhoneField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Номер телефона",
                    style: TextStyle(
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'Merriweather-Regular',
                        fontSize: 16)),
                Text("*",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'Merriweather-Regular',
                        fontSize: 16)),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 75,
                  height: 50,
                  child: TextFormField(
                    controller: widget.controllerPrefix,
                    onChanged: (text) {
                      setState(() {
                        widget.inputTextPrefix = text;
                      });
                    },
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: PRIMARY_DARK_COLOR, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_DARK_COLOR)),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "8"),
                  ),
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    controller: widget.controller,
                    onChanged: (text) {
                      setState(() {
                        widget.inputText = text;
                      });
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: PRIMARY_DARK_COLOR, width: 1.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: PRIMARY_DARK_COLOR)),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: hidingIcon(),
                      hintText: "Номер телефона",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Widget? hidingIcon() {
    if (widget.inputText.length > 0) {
      return Icon(Icons.check, color: Colors.green);
    } else {
      return null;
    }
  }
}
