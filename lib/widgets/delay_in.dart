import 'package:flutter/material.dart';

class DelayIn extends StatefulWidget {
  final Duration delay;
  final Widget child;

  const DelayIn({
    required this.delay,
    required this.child,
    key,
  }) : super(key: key);

  @override
  _DelayInState createState() => _DelayInState();
}

class _DelayInState extends State<DelayIn> {
  bool _visible = false;

  @override
  initState() {
    super.initState();

    Future.delayed(widget.delay, () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  build(context) {
    if (!_visible) {
      return Container();
    }

    return widget.child;
  }
}
