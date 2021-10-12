import 'package:endless/endless.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';

Set<PaginatedSearchBarState> resolveSearchStates({
  required Set<EndlessState> listStates,
  required bool isFocused,
}) {
  final states = <PaginatedSearchBarState>{};

  // The search bar is searching if it is loading after the endless list view has been
  // marked as it will clear its items when the current load finishes.
  if (listStates.contains(EndlessState.loading) &&
      listStates.contains(EndlessState.willClear)) {
    states.add(PaginatedSearchBarState.searching);
  }

  if (isFocused) {
    states.add(PaginatedSearchBarState.focused);
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
