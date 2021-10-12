// ignore_for_file: prefer_void_to_null

import 'package:flutter/material.dart';
import 'package:state_property/state_property.dart';

enum PaginatedSearchBarState {
  /// Present when the search bar is searching for items. Triggered when they update their search
  /// query in the input.
  searching,

  /// Present when the search bar is fetching a page of items either as a result of a modified search query
  /// or by scrolling to the bottom of the list view and triggering the next page load.
  loading,

  /// Present when the search bar has no matching items for the current search query.
  empty,

  /// Present when the search bar has no more items to fetch for the current search query. Triggered
  /// when the [PaginatedSearchBar.onSearch] function returns fewer than [PaginatedSearchBar.pageLimit]
  /// items or [EndlessPaginationDelegate.maxPage] has been reached and no more items can be fetched.
  done,

  /// Present the input is currently focused.
  focused,
}

class PaginatedSearchBarBuilderStateProperty
    extends WidgetStateProperty<PaginatedSearchBarState> {
  PaginatedSearchBarBuilderStateProperty(resolve) : super(resolve);

  /// The most flexible state property that allows for dynamically resolving the builder
  /// function based on the state of the scroll view.
  static PaginatedSearchBarBuilderStateProperty resolveWith(
          StatefulWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveWith<PaginatedSearchBarState, Widget>(
                (states) => builder(context, states)),
      );

  /// Resolves the given builder in all cases regardless of the state of the scroll view.
  static PaginatedSearchBarBuilderStateProperty all(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.all<PaginatedSearchBarState, Widget>(
                () => builder(context)),
      );

  /// Resolves the given builder if the scroll view is currently in the searching state.
  static PaginatedSearchBarBuilderStateProperty searching(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveState<PaginatedSearchBarState, Widget>(
          () => builder(context),
          PaginatedSearchBarState.searching,
        ),
      );

  /// Resolves the given builder if the scroll view is currently in the searching state.
  static PaginatedSearchBarBuilderStateProperty loading(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveState<PaginatedSearchBarState, Widget>(
          () => builder(context),
          PaginatedSearchBarState.loading,
        ),
      );

  /// Resolves the given builder if the scroll view is currently in the searching state.
  static PaginatedSearchBarBuilderStateProperty focused(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveState<PaginatedSearchBarState, Widget>(
          () => builder(context),
          PaginatedSearchBarState.focused,
        ),
      );

  /// Resolves the given builder if the scroll view is currently in the empty state.
  static PaginatedSearchBarBuilderStateProperty empty(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveState<PaginatedSearchBarState, Widget>(
          () => builder(context),
          PaginatedSearchBarState.empty,
        ),
      );

  /// Resolves the given builder if the scroll view is currently in the done state.
  static PaginatedSearchBarBuilderStateProperty done(
          StatelessWidgetResolver builder) =>
      PaginatedSearchBarBuilderStateProperty(
        (BuildContext context) =>
            StateProperty.resolveState<PaginatedSearchBarState, Widget>(
          () => builder(context),
          PaginatedSearchBarState.done,
        ),
      );

  /// Resolves `null` as the value regardless of the state of the scroll view.
  static PaginatedSearchBarBuilderStateProperty never() =>
      PaginatedSearchBarBuilderStateProperty(
          (_context) => StateProperty.never<PaginatedSearchBarState>());
}

class PaginatedSearchBarStyleStateProperty<ResolverType>
    implements StateProperty<PaginatedSearchBarState, ResolverType?> {
  final StateProperty<PaginatedSearchBarState, ResolverType?> _stateProperty;

  PaginatedSearchBarStyleStateProperty(this._stateProperty);

  @override
  ResolverType? resolve(states) {
    return _stateProperty.resolve(states);
  }

  static PaginatedSearchBarStyleStateProperty<ResolverType> resolveWith<
              ResolverType>(
          StatefulResolver<PaginatedSearchBarState, ResolverType?> builder) =>
      PaginatedSearchBarStyleStateProperty<ResolverType>(
        StateProperty.resolveWith<PaginatedSearchBarState, ResolverType?>(
            builder),
      );

  static PaginatedSearchBarStyleStateProperty<ResolverType>
      resolveState<ResolverType>(
    StatelessResolver<ResolverType?> builder,
    PaginatedSearchBarState state,
  ) =>
          PaginatedSearchBarStyleStateProperty<ResolverType>(
            StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
              builder,
              state,
            ),
          );

  static PaginatedSearchBarStyleStateProperty<ResolverType> done<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
      PaginatedSearchBarStyleStateProperty<ResolverType>(
        StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
          builder,
          PaginatedSearchBarState.done,
        ),
      );

  static PaginatedSearchBarStyleStateProperty<ResolverType>
      searching<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
          PaginatedSearchBarStyleStateProperty<ResolverType>(
            StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
              builder,
              PaginatedSearchBarState.searching,
            ),
          );

  static PaginatedSearchBarStyleStateProperty<ResolverType>
      loading<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
          PaginatedSearchBarStyleStateProperty<ResolverType>(
            StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
              builder,
              PaginatedSearchBarState.loading,
            ),
          );

  static PaginatedSearchBarStyleStateProperty<ResolverType> empty<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
      PaginatedSearchBarStyleStateProperty<ResolverType>(
        StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
          builder,
          PaginatedSearchBarState.empty,
        ),
      );

  static PaginatedSearchBarStyleStateProperty<ResolverType>
      focused<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
          PaginatedSearchBarStyleStateProperty<ResolverType>(
            StateProperty.resolveState<PaginatedSearchBarState, ResolverType?>(
              builder,
              PaginatedSearchBarState.focused,
            ),
          );

  static PaginatedSearchBarStyleStateProperty<ResolverType> all<ResolverType>(
    StatelessResolver<ResolverType?> builder,
  ) =>
      PaginatedSearchBarStyleStateProperty<ResolverType>(
        StateProperty.all<PaginatedSearchBarState, ResolverType?>(builder),
      );

  static PaginatedSearchBarStyleStateProperty<Null> never() =>
      PaginatedSearchBarStyleStateProperty<Null>(
        StateProperty.never<PaginatedSearchBarState>(),
      );
}
