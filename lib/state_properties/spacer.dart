import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:paginated_search_bar/widgets/line_spacer.dart';

Widget resolveSpacerStateProperty({
  required BuildContext context,
  required Set<PaginatedSearchBarState> states,
  required bool isExpanded,
  required Widget? Function(BuildContext context)? spacerBuilder,
  required PaginatedSearchBarBuilderStateProperty? spacerBuilderState,
}) {
  if (spacerBuilderState != null) {
    return spacerBuilderState.resolve(context, states) ?? const SizedBox();
  }

  if (isExpanded) {
    if (spacerBuilder != null) {
      return spacerBuilder(context) ?? const SizedBox();
    }
    return const LineSpacer();
  }

  return const SizedBox();
}
