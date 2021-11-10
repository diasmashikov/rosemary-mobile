import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:rosemary/data/models/radioItem.dart';

class RadioGroup extends StatefulWidget {
  final List<RadioItem> radioGroupList;
  final int chosenValue;

  const RadioGroup(
      {Key? key, required this.radioGroupList, required this.chosenValue})
      : super(key: key);
  @override
  State<StatefulWidget> createState() =>
      RadioGroupWidget(radioGroupList: radioGroupList);
}

class RadioGroupWidget extends State<RadioGroup>
    with AutomaticKeepAliveClientMixin<RadioGroup> {
  final List<RadioItem> radioGroupList;
  late int chosenValue;
  // Default Radio Button Item

  // Group Value for Radio Button.

  RadioGroupWidget({required this.radioGroupList});

  @override
  void initState() {
    super.initState();
    print(chosenValue);
    chosenValue = widget.chosenValue;
  }

  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: radioGroupList
          .map((data) => RadioListTile(
                contentPadding: EdgeInsets.all(0),
                activeColor: PRIMARY_DARK_COLOR,
                title: Text("${data.name}"),
                groupValue: chosenValue,
                value: data.index,
                onChanged: (val) {
                  setState(() {
                    chosenValue = data.index;
                    print(chosenValue);
                  });
                },
              ))
          .toList(),
    );
  }

  @override

  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
