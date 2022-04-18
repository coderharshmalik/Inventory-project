import 'package:flutter/material.dart';
import '../constants.dart';

class IconContent extends StatelessWidget {
  final IconData iconData;
  final String text;

  IconContent({
    @required this.iconData,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: kFunctionTextStyle,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Icon(
                    iconData,
                    size: 80.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
