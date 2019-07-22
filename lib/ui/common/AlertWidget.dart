import 'package:farmsmart_flutter/ui/common/roundedButton.dart';
import 'package:farmsmart_flutter/ui/mockData/MockRoundedButtonViewModel.dart';
import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text("TEST"),
      onPressed: () => _confirmDialog(context),
    );
  }

  Future<bool> _confirmDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Begin Stage 2"),
              titleTextStyle: TextStyle(
                  color: Color(0xff1a1b46),
                  fontSize: 27,
                  fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Are you sure you want to begin Stage 2 - Planting?",
                    style: TextStyle(
                        color: Color(0xff1a1b46),
                        fontSize: 17,
                        fontWeight: FontWeight.normal),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: _showBla(),
                  )
                ],
              ),);
        });
  }

  List<Widget> _showBla() {
    List<Widget> listBuilder = [
      Expanded(
        child: RoundedButton(
          viewModel: RoundedButtonViewModel(title: "Cancel", onTap: () {}),
          style: RoundedButtonStyle.actionSheetLargeRoundedButton().copyWith(height: 48, width: 112),
        ),
      )
    ];
    listBuilder.add(SizedBox(
      width: 12,
    ));
    listBuilder.add(Expanded(
      child: RoundedButton(
        viewModel: RoundedButtonViewModel(title: "Yes", onTap: () {}),
        style: RoundedButtonStyle.actionSheetLargeRoundedButton()
            .copyWith(height: 48, width: 112, backgroundColor: Color(0xff24d900), buttonTextStyle: TextStyle(color: Color(0xffffffff))),
      ),
    ));
    return listBuilder;
  }
}
