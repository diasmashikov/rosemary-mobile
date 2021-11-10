import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ExpansionTileFrequentQuestionsContent extends StatefulWidget {
  final String description;
  final Color expansionTileTextColor;
  const ExpansionTileFrequentQuestionsContent(
      {Key? key,
      required this.description,
      required this.expansionTileTextColor})
      : super(key: key);

  @override
  _ExpansionTileFrequentQuestionsContentState createState() =>
      _ExpansionTileFrequentQuestionsContentState();
}

class _ExpansionTileFrequentQuestionsContentState
    extends State<ExpansionTileFrequentQuestionsContent>
    with AutomaticKeepAliveClientMixin<ExpansionTileFrequentQuestionsContent> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
      widget.description,
      style: TextStyle(
          color: widget.expansionTileTextColor,
          fontFamily: 'Merriweather-Regular',
          fontSize: 11.5.sp),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
