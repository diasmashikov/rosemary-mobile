import 'package:flutter/material.dart';

class ExpansionTileListener {
  Color expansionTileTextColor;
  void Function(VoidCallback fn) setStateCall;
  ExpansionTileListener(
      {required this.expansionTileTextColor, required this.setStateCall});
      
  void onTileExpanded(bool expanded) {
    setStateCall(() {
      if (expanded) {
        expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
      } else {
        expansionTileTextColor = Color.fromRGBO(58, 67, 59, 1);
      }
    });
  }
}
