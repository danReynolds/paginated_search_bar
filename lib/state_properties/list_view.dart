import 'package:endless/endless.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';

/// By default the paginated search bar will show a border between the search input and
/// the list view when the list view is expanded (the list view either has items,
/// an empty state to show or a placeholder to show).
EndlessStateProperty resolveHeaderStateProperty({
  required PaginatedSearchBarBuilderStateProperty? headerBuilderState,
  required Widget? Function(BuildContext context)? headerBuilder,
  required Set<PaginatedSearchBarState> states,
}) {
  return EndlessStateProperty.all(
    (context) {
      if (headerBuilderState != null) {
        return headerBuilderState.resolve(
          context,
          states,
        );
      } else if (headerBuilder != null) {
        return headerBuilder(context);
      }
    },
  );
}

EndlessStateProperty resolveEmptyStateProperty({
  required PaginatedSearchBarBuilderStateProperty? emptyBuilderState,
  required Widget? Function(BuildContext context)? emptyBuilder,
  required PaginatedSearchBarBuilderStateProperty? placeholderBuilderState,
  required Widget? Function(BuildContext context)? placeholderBuilder,
  required Set<PaginatedSearchBarState> states,
  required bool hasResolvedFirstSearchAboveMinLength,
}) {
  return EndlessStateProperty.all(
    (context) {
      // If empty (the list view wouldn't call this code if it was) and it has already
      // resolved its first search above the min length, then we know we are able to show
      // the empty state.
      if (hasResolvedFirstSearchAboveMinLength) {
        if (emptyBuilderState != null) {
          return emptyBuilderState.resolve(
            context,
            states,
          );
        }
        if (emptyBuilder != null) {
          return emptyBuilder(context);
        }

        return null;
      }

      if (placeholderBuilderState != null) {
        return placeholderBuilderState.resolve(
          context,
          states,
        );
      }

      if (placeholderBuilder != null) {
        return placeholderBuilder(context);
      }
    },
  );
}

EndlessStateProperty resolveLoadingStateProperty({
  required PaginatedSearchBarBuilderStateProperty? loadingBuilderState,
  required Widget? Function(BuildContext context)? loadingBuilder,
  required Set<PaginatedSearchBarState> states,
}) {
  return EndlessStateProperty.all(
    (context) {
      if (loadingBuilderState != null) {
        return loadingBuilderState.resolve(context, states);
      }

      if (states.contains(PaginatedSearchBarState.loading) &&
          !states.contains(PaginatedSearchBarState.searching)) {
        if (loadingBuilder != null) {
          return loadingBuilder(context);
        }
        return const EndlessDefaultLoadingIndicator();
      }

      return null;
    },
  );
}

EndlessStateProperty resolveFooterStateProperty({
  required PaginatedSearchBarBuilderStateProperty? footerBuilderState,
  required Widget? Function(BuildContext context)? footerBuilder,
  required Set<PaginatedSearchBarState> states,
}) {
  return EndlessStateProperty.all(
    (context) {
      if (footerBuilderState != null) {
        return footerBuilderState.resolve(
          context,
          states,
        );
      } else if (footerBuilder != null) {
        return footerBuilder(context);
      }
    },
  );
}
