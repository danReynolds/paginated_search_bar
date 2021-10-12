import 'package:endless/endless.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:paginated_search_bar/utils/paginated_search_state.dart';

/// By default the paginated search bar will show a border between the search input and
/// the list view when the list view is expanded (the list view either has items,
/// an empty state to show or a placeholder to show).
EndlessStateProperty resolveHeaderStateProperty({
  required PaginatedSearchBarBuilderStateProperty? headerBuilderState,
  required Widget? Function(BuildContext context)? headerBuilder,
  required Set<PaginatedSearchBarState> searchBarStates,
}) {
  return EndlessStateProperty.resolveWith(
    (context, listStates) {
      final newSearchBarStates = resolveSearchStates(
        listStates: listStates,
        isFocused: searchBarStates.contains(PaginatedSearchBarState.focused),
      );

      if (headerBuilderState != null) {
        return headerBuilderState.resolve(
          context,
          newSearchBarStates,
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
  required Set<PaginatedSearchBarState> searchBarStates,
  required bool hasResolvedFirstSearchAboveMinLength,
}) {
  return EndlessStateProperty.resolveWith(
    (context, listStates) {
      final newSearchBarStates = resolveSearchStates(
        listStates: listStates,
        isFocused: searchBarStates.contains(PaginatedSearchBarState.focused),
      );

      if (hasResolvedFirstSearchAboveMinLength) {
        if (emptyBuilderState != null) {
          return emptyBuilderState.resolve(
            context,
            newSearchBarStates,
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
          newSearchBarStates,
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
  required Set<PaginatedSearchBarState> searchBarStates,
}) {
  return EndlessStateProperty.resolveWith(
    (context, listStates) {
      final newSearchBarStates = resolveSearchStates(
        listStates: listStates,
        isFocused: searchBarStates.contains(PaginatedSearchBarState.focused),
      );

      if (loadingBuilderState != null) {
        return loadingBuilderState.resolve(context, newSearchBarStates);
      }

      if (newSearchBarStates.contains(PaginatedSearchBarState.loading) &&
          !newSearchBarStates.contains(PaginatedSearchBarState.searching)) {
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
  required Set<PaginatedSearchBarState> searchBarStates,
}) {
  return EndlessStateProperty.resolveWith(
    (context, listStates) {
      final newSearchBarStates = resolveSearchStates(
        listStates: listStates,
        isFocused: searchBarStates.contains(PaginatedSearchBarState.focused),
      );

      if (footerBuilderState != null) {
        return footerBuilderState.resolve(
          context,
          newSearchBarStates,
        );
      } else if (footerBuilder != null) {
        return footerBuilder(context);
      }
    },
  );
}
