import 'package:endless/endless.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';

Set<PaginatedSearchBarState> resolveSearchStates({
  required Set<EndlessState> listStates,
  required bool isSearching,
  required bool isFocused,
  required bool isExpanded,
}) {
  final states = <PaginatedSearchBarState>{};

  if (isSearching) {
    states.add(PaginatedSearchBarState.searching);
  }

  if (isFocused) {
    states.add(PaginatedSearchBarState.focused);
  }

  if (isExpanded) {
    states.add(PaginatedSearchBarState.expanded);
  }

  if (listStates.contains(EndlessState.done)) {
    states.add(PaginatedSearchBarState.done);
  }

  if (listStates.contains(EndlessState.loading)) {
    states.add(PaginatedSearchBarState.loading);
  }

  if (listStates.contains(EndlessState.empty)) {
    states.add(PaginatedSearchBarState.empty);
  }

  return states;
}
