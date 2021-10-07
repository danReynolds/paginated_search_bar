import 'package:flutter/material.dart';

class Cached extends StatefulWidget {
  final bool dirty;
  final Widget child;

  const Cached({
    required this.dirty,
    required this.child,
    key,
  }) : super(key: key);

  @override
  _CachedState createState() => _CachedState();
}

class _CachedState extends State<Cached> {
  Widget? _oldWidget;

  @override
  build(context) {
    if (widget.dirty) {
      _oldWidget = widget.child;
    }

    return _oldWidget!;
  }
}
