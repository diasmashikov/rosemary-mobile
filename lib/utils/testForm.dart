import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';

import 'package:sizer/sizer.dart';

class TestTextFormFieldPost extends StatefulWidget {
  final String formName;
  final String hint;
  final TextEditingController controller;
  final int minLin;
  final int maxLin;
  String content;
  final Function validator;
  //final GlobalKey<FormState> key;

  TestTextFormFieldPost(
      {required this.formName,
      required this.controller,
      required this.minLin,
      required this.maxLin,
      required this.content,
      required this.validator,
      required this.hint,
      });

  @override
  _TestTextFormFieldPostState createState() => _TestTextFormFieldPostState();
}

class _TestTextFormFieldPostState extends State<TestTextFormFieldPost> {
  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.content;
    return Container(
        margin: EdgeInsets.symmetric(vertical: 1.5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.formName,
                style: TextStyle(
                    color: Color.fromRGBO(58, 67, 59, 1),
                    fontFamily: 'Merriweather-Regular',
                    fontSize: 11.sp)),
            SizedBox(
              height: 1.h,
            ),
            Container(
              width: double.infinity,
              child: TextFormField(
                key: widget.key,
                enableSuggestions: false,
                controller: widget.controller,
                maxLines: widget.maxLin,
                minLines: widget.minLin,
                decoration: InputDecoration(
                  errorText: widget.validator(),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: PRIMARY_DARK_COLOR, width: 0.2.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: PRIMARY_DARK_COLOR)),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  hintText: widget.hint,
                ),
              ),
            )
          ],
        ));
  }
}
