import 'package:flutter/material.dart';

class DialogTitle extends StatelessWidget {
  const DialogTitle(
    this.text, {
    Key? key,
    this.actions,
  }) : super(key: key);

  final String text;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const Spacer(),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
