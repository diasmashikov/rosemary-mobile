import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';


class AppTextFormField extends StatefulWidget {
  final String formName;
  final String hintName;
  String inputText;
  final TextEditingController controller;

  AppTextFormField(
      {required this.formName,
      required this.hintName,
      required this.controller, required this.inputText});

  @override
  _AppTextFormFieldState createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
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
                onChanged: (text) {
                  setState(() {
                    widget.inputText = text;
                  });
                },
                decoration: InputDecoration(
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
