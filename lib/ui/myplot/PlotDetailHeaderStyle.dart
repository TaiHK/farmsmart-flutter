import 'package:flutter/material.dart';
import 'PlotListItem.dart';

class PlotDetailHeaderStyle implements PlotListItemStyle {
  final Color primaryColor = const Color(0xff24d900);
  final Color dividerColor = const Color(0x00000000);
  final Color detailTextBackgroundColor = const Color(0x1425df0c);
  final Color overlayColor = const Color(0x1425df0c);

  final EdgeInsets detailTextEdgePadding = const EdgeInsets.only(left: 12, top: 5.5, right: 12, bottom: 5.5);
  final EdgeInsets dividerEdgePadding = const EdgeInsets.only(left: 25.0);
  final EdgeInsets cardEdgePadding = const EdgeInsets.all(0);
  final EdgeInsets edgePadding = const EdgeInsets.only(left: 32.0, top: 27.0, right: 32.0, bottom: 27.0);

  final TextStyle subtitleTextStyle = const TextStyle(fontSize: 15, fontWeight: FontWeight.normal, color: Color(0xff767690));
  final TextStyle detailTextStyle = const TextStyle(fontSize: 11, fontWeight: FontWeight.normal, color: Color(0xff25df0c));
  final TextStyle titleTextStyle = const TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: Color(0xff1a1b46));

  final BorderRadius detailTextBorderRadius = const BorderRadius.all(Radius.circular(20.0));

  final double elevation = 0.0;
  final double imageSize = 80.0;
  final double headingLineSpace = 0;
  final double detailLineSpace = 16;
  final double imageLineSpace = 20;
  final int maxLineText = 1;
  final double circularSize = 87;
  final double circularLineWidth = 3;

  const PlotDetailHeaderStyle();
}