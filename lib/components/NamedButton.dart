import 'package:flutter/material.dart';
class NamedButton extends StatelessWidget {
  final String title;
  final Function ontap;
  final Color colorr;
  NamedButton({@required this.title,@required this.colorr, this.ontap});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colorr,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: ontap,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            '$title',
            style: TextStyle(color:Colors.black),
          ),
        ),
      ),
    );
  }
}