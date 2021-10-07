import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';

BoxDecoration? resolveContainerStyleStateProperty({
  required PaginatedSearchBarStyleStateProperty<BoxDecoration>?
      containerDecorationState,
  required BoxDecoration? containerDecoration,
  required Set<PaginatedSearchBarState> states,
}) {
  if (containerDecorationState != null) {
    return containerDecorationState.resolve(states);
  }

  if (containerDecoration != null) {
    return containerDecoration;
  }

  return BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.all(Radius.circular((8))),
    boxShadow: states.contains(PaginatedSearchBarState.focused)
        ? [
            BoxShadow(
              color: Colors.black12.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ]
        : [
            BoxShadow(
              color: Colors.black12.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
  );
}

TextStyle? resolveInputStyleStateProperty({
  required PaginatedSearchBarStyleStateProperty<TextStyle>? inputStyleState,
  required TextStyle? inputStyle,
  required Set<PaginatedSearchBarState> states,
}) {
  if (inputStyleState != null) {
    return inputStyleState.resolve(states);
  }

  if (inputStyle != null) {
    return inputStyle;
  }

  return const TextStyle(fontSize: 20, color: Colors.grey);
}

InputDecoration? resolveInputDecorationStateProperty({
  required PaginatedSearchBarStyleStateProperty<InputDecoration>?
      inputDecorationState,
  required InputDecoration? inputDecoration,
  required Set<PaginatedSearchBarState> states,
  required String? hintText,
}) {
  if (inputDecorationState != null) {
    return inputDecorationState.resolve(states);
  }

  if (inputDecoration != null) {
    return inputDecoration;
  }

  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(fontSize: 18, color: Colors.grey),
    prefixIcon: const Icon(
      Icons.search,
      size: 26,
      color: Colors.grey,
    ),
    suffix: states.contains(PaginatedSearchBarState.searching)
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          )
        : null,
    border: const OutlineInputBorder(
      borderSide: BorderSide.none,
    ),
  );
}
