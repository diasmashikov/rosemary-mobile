import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';


class AppTextFormFieldPassword extends StatefulWidget {
  final String formName;
  final String hintName;
  String inputText;
  final TextEditingController controller;

  AppTextFormFieldPassword(
      {required this.formName,
      required this.hintName,
      required this.controller, required this.inputText});

  @override
  _AppTextFormFieldPasswordState createState() => _AppTextFormFieldPasswordState();
}

class _AppTextFormFieldPasswordState extends State<AppTextFormFieldPassword> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(widget.formName,
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
            Container(
              width: double.infinity,
              height: 50,
              child: TextFormField(
                controller: widget.controller,
                obscureText: true,
                onChanged: (text) {
                  setState(() {
                    widget.inputText = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: widget.hintName,
                  enabledBorder: const OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: PRIMARY_DARK_COLOR, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PRIMARY_DARK_COLOR)),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  suffixIcon: hidingIcon(),
                  hintText: widget.hintName,
                ),
              ),
            )
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
