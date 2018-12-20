import 'package:flutter/material.dart';

class ListDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Divider(),
    );
  }
}
