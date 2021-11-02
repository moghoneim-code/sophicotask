import 'package:flutter/material.dart';

class TekdiButton extends StatelessWidget {

  final String title;
  final Color color;
  final Function onPressed;

  TekdiButton({this.title, this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(25)
      ),
      color: color,
      textColor: Colors.white,
      child: Container(
        height: 50,
        child: Center(
          child: Text(
            title,textScaleFactor: 1.0,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
