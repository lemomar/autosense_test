import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DialogSubtitle extends StatelessWidget {
  const DialogSubtitle(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
