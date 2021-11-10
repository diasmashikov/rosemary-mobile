import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';

class CustomDropDown extends StatefulWidget {
  final String chosenElement;
  final List<String> itemsToList;
  final String elementName;
  final String elementHint;


  CustomDropDown(
      {required this.chosenElement,
      required this.itemsToList,
      required this.elementName,
      required this.elementHint});

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  var _chosenElement;
  @override
  void initState() {
    super.initState();
    _chosenElement = widget.chosenElement;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.elementName,
              style: TextStyle(
                  color: Color.fromRGBO(58, 67, 59, 1),
                  fontFamily: 'Merriweather-Bold',
          fontSize: 20)),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4),
            width: double.infinity,
            child: DropdownButton(
                isExpanded: true,
                value: _chosenElement,
                items: widget.itemsToList
                    .map<DropdownMenuItem<String>>((element) {
                  return DropdownMenuItem<String>(
                    value: element,
                    child: Text(element,
                        style: TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(58, 67, 59, 1),
                            fontFamily: 'SolomonSans-SemiBold')),
                  );
                }).toList(),
                hint: Text(widget.elementHint,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(58, 67, 59, 1),
                        fontFamily: 'SolomonSans-SemiBold')),
                onChanged: (element) {
                  setState(() {
                    _chosenElement = element;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
