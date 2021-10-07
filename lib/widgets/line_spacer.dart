import 'package:flutter/material.dart';

class LineSpacer extends StatelessWidget {
  final EdgeInsets? margin;

  const LineSpacer({this.margin, key}) : super(key: key);

  @override
  build(context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
    );
  }
}
