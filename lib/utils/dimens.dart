import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';

// We define here generic margins for the app

abstract class Margins {
  static SizedBox generalListBigMargin() {
    return SizedBox(height: 20);
  }

  static SizedBox generalListMargin() {
    return SizedBox(height: 16);
  }

  static SizedBox generalListSmallMargin() {
    return SizedBox(height: 12);
  }

  static SizedBox generalHorizontalPadding() {
    return SizedBox(width: 16);
  }

  static SizedBox generalListSmallerMargin() {
    return SizedBox(height: 7);
  }
}

abstract class Paddings {
  static boxBigPadding() {
    return EdgeInsets.all(20);
  }

  static boxSmallPadding() {
    return EdgeInsets.all(12);
  }

  static boxPadding() {
    return EdgeInsets.all(16);
  }

  static articlePadding() {
    return EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 16);
  }

  static listOfArticlesPadding() {
    return EdgeInsets.only(left: 25.0, top: 8, bottom: 0, right: 25.0);
  }

  static leftPaddingSmall() {
    return EdgeInsets.only(left: 10);
  }

  static sidesPadding() {
    return EdgeInsets.only(left: 15, right: 15);
  }

  static rightPaddingSmall() {
    return EdgeInsets.only(right: 10);
  }

  static bottomPaddingSmall() {
    return EdgeInsets.only(bottom: 10);
  }

  static title(){
    return EdgeInsets.only(left: 25, top: 30, right: 5, bottom: 20);
  }
}


abstract class Dividers {

  static expandableDivider() {
    return Divider(height: 4, color: Color(black));
  }

  static listDividerLine() {
    return Divider(
      height: 1.5,
      color: Color(primaryGrey),
      indent: 30,
    );
  }

}

const double bottomBarIconSize = 30.0;
const double appBarIconSize = 30.0;
const double detailScreenImageHeight = 200.0;
const double detailScreenImageWidth = 400.0;
const double arrowIconSize = 17.0;
const double listImageHeight = 90.0;
const double listImageWidth = 140.0;
const double listItemHeight = 101.0;
const int listViewFlex = 6;
const int titleMaxLines = 1;
const int summaryMaxLines = 4;
