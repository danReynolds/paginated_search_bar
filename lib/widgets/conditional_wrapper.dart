import 'package:flutter/material.dart';

class ConditionalWrapper extends StatelessWidget {
  final Widget child;
  final Widget Function(Widget child) wrapperBuilder;
  final bool condition;

  const ConditionalWrapper({
    required this.child,
    required this.wrapperBuilder,
    required this.condition,
    key,
  }) : super(key: key);

  @override
  build(context) {
    if (condition) {
      return wrapperBuilder(child);
    }
    return child;
  }
}
