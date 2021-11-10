import 'package:flutter/material.dart';
import 'package:rosemary/constants/colors.dart';
import 'package:sizer/sizer.dart';

class ExpanstionTileComponents {
  
  Text buildExpansionTileTitle(
      {required String title, required Color expansionTileTextColor}) {
    return Text(
      title,
      style: TextStyle(
          color: expansionTileTextColor,
          fontFamily: 'Merriweather-Bold',
          fontSize: 11.sp),
    );
  }

}
