library paginated_search_bar;

import 'package:endless/endless.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:paginated_search_bar/state_properties/list_view.dart';
import 'package:paginated_search_bar/state_properties/spacer.dart';
import 'package:paginated_search_bar/state_properties/styles.dart';
import 'package:paginated_search_bar/utils/paginated_search_state.dart';
import 'package:paginated_search_bar/widgets/conditional_wrapper.dart';
import 'package:paginated_search_bar/widgets/line_spacer.dart';
import 'package:rxdart/rxdart.dart';

class PaginatedSearchBar<T> extends StatefulWidget {
  /// The duration for animating the size of the results container provided to
  /// the [AnimatedSize] widget.
  final Duration? resizeDuration;

  /// The duration for debouncing search when the user types in the search bar.
  final Duration? searchDebounceDuration;

  /// The hint text to show in the [TextFormField].
  final String? hintText;

  /// The minimum search length before searching.
  final int minSearchLength;

  /// The search function to perform when the user types into the search bar. Returns a list of items
  /// to display in the search results list.
  final Future<List<T>> Function({
    /// The current search query matching what the user has typed in the search bar.
    required String searchQuery,

    /// The page index of search results to load for the search query. Starts at 0 and increments as the user
    /// scrolls down the list of search results triggering a new page load.
    required int pageIndex,

    /// The number of items to return per page. If fewer than `pageSize` items are returned, the search bar knows
    /// that no further search results can be returned for the current search query and it will not load any more as the user
    /// scrolls down the list of results.
    required int pageSize,
  }) onSearch;

  /// The maximum height of the container for search bar and results.
  final double? maxHeight;

  /// The pagination controller for manipulating the list of search results using the [EndlessPaginationListView].
  final EndlessPaginationController<T>? listController;

  /// The pagination delegate for specifying page size and the maximum number of pages to load in the results list
  /// using the [EndlessPaginationListView].
  final EndlessPaginationDelegate? paginationDelegate;

  /// The text controller for the search bar.
  final TextEditingController? inputController;

  /// Whether to initially focus the search bar.
  final bool autoFocus;

  /// The padding value to display between each item.
  final double itemPadding;

  /// The padding to display around the container of search results.
  final EdgeInsets? padding;

  /// The handler for when a user submits the search bar input field by hitting `enter`. Provides the top item from
  /// the current of search results as the implied chosen result.
  final void Function({required T item, required String searchQuery})? onSubmit;

  /// The style for the text in the search bar input.
  final TextStyle? inputStyle;

  /// The [StateProperty] for customizing the style of the text in the search bar input based on the active set of
  /// [PaginatedSearchBarState] states.
  final PaginatedSearchBarStyleStateProperty<TextStyle>? inputStyleState;

// The decoration of the search bar input.
  final InputDecoration? inputDecoration;

  /// The [StateProperty] for customizing the decoration of the search bar input based on the active set of
  /// [PaginatedSearchBarState] states.
  final PaginatedSearchBarStyleStateProperty<InputDecoration>?
      inputDecorationState;

  /// The decoration of the container around the entire search bar and results list.
  final BoxDecoration? containerDecoration;

  /// The [StateProperty] for customizing the decoration of the container around the entire search bar and
  /// results list based on the active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarStyleStateProperty<BoxDecoration>?
      containerDecorationState;

  /// The builder for the spacer shown between the search bar input and results list. Defaults to a [LineSpacer].
  final Widget Function(BuildContext context)? spacerBuilder;

  /// The state property for building the spacer shown between the search bar input and results list based on the
  /// active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? spacerBuilderState;

  /// The builder for the header shown above the search results list.
  final Widget Function(BuildContext context)? headerBuilder;

  /// The state property for building the header shown above the search results list based on the
  /// active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? headerBuilderState;

  /// The builder for the items in the search results list.
  final Widget Function(
    BuildContext context, {
    required T item,
    required int index,
  }) itemBuilder;

  /// The builder for the empty state shown when no items are returned from a search.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// The state property for customizing the building of the empty state shown when no items are returned from a search
  /// based on the active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? emptyBuilderState;

  /// The builder for the placeholder shown before any results have been searched for.
  final Widget Function(BuildContext context)? placeholderBuilder;

  /// The state property for customizing the building of the placeholder shown when before any results have been searched for
  /// based on the active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? placeholderBuilderState;

  /// The builder for the loader shown when the user pages down the search results list.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// The state property for customizing the building of the loader shown when the user pages down the search results list
  /// based on the active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? loadingBuilderState;

  /// The builder for the footer below above the search results list.
  final Widget Function(BuildContext context)? footerBuilder;

  /// The state property for building the footer shown below the search results list based on the
  /// active set of [PaginatedSearchBarState] states.
  final PaginatedSearchBarBuilderStateProperty? footerBuilderState;

  const PaginatedSearchBar({
    required this.itemBuilder,
    required this.onSearch,
    this.containerDecoration,
    this.containerDecorationState,
    this.inputStyle,
    this.inputStyleState,
    this.inputDecoration,
    this.inputDecorationState,
    this.hintText,
    this.spacerBuilder,
    this.spacerBuilderState,
    this.headerBuilder,
    this.headerBuilderState,
    this.emptyBuilder,
    this.emptyBuilderState,
    this.placeholderBuilder,
    this.placeholderBuilderState,
    this.footerBuilder,
    this.footerBuilderState,
    this.loadingBuilder,
    this.loadingBuilderState,
    this.maxHeight,
    this.paginationDelegate,
    this.listController,
    this.onSubmit,
    this.inputController,
    this.padding = const EdgeInsets.all(16),
    this.itemPadding = 16,
    this.searchDebounceDuration = const Duration(milliseconds: 200),
    this.autoFocus = false,
    this.minSearchLength = 3,
    this.resizeDuration = const Duration(milliseconds: 250),
    key,
  }) : super(key: key);

  @override
  _PaginatedSearchBarState<T> createState() => _PaginatedSearchBarState<T>();
}

class _PaginatedSearchBarState<T> extends State<PaginatedSearchBar<T>>
    with TickerProviderStateMixin {
  late TextEditingController _inputController;
  final _debouncedSearchSubject = BehaviorSubject<String>();
  late EndlessPaginationController<T> _paginatedListViewController;
  late EndlessPaginationDelegate _paginationDelegate;
  final _listViewKey = GlobalKey();

  String _searchQuery = '';
  String _prevSearchQuery = '';
  bool _isFocused = false;
  bool _isExpanded = false;
  bool _hasResolvedFirstSearchAboveMinLength = false;
  Set<PaginatedSearchBarState> _searchBarStates = {
    PaginatedSearchBarState.empty
  };

  T? _topItem;

  @override
  dispose() {
    super.dispose();
    _inputController.dispose();
  }

  @override
  void initState() {
    super.initState();

    _inputController = widget.inputController ?? TextEditingController();
    _paginatedListViewController =
        widget.listController ?? EndlessPaginationController();
    _paginationDelegate = widget.paginationDelegate ??
        EndlessPaginationDelegate(
          pageSize: 5,
        );

    _debouncedSearchSubject.debounce((value) {
      return TimerStream(
        true,
        // Use a zero duration debounce when the user backs out of the min value so it instantly hides results. Otherwise,
        // when they are typing above the min results value, we use a debounce of 200ms to delay the search requests
        value.length >= widget.minSearchLength
            ? widget.searchDebounceDuration!
            : Duration.zero,
      );
    }).listen(
      (value) async {
        // Do not call set state after changing the search query as we want to delay updating
        // until the list view loading begins so that the first set of states after starting
        // a search will include both the searching state and the list view's loading state
        _prevSearchQuery = _searchQuery;
        _searchQuery = value;

        if (_searchQuery.length < widget.minSearchLength) {
          // If the search query is less than the minimum, we can immediately call setState
          // since there will be no search to wait for.
          setState(() {
            // We also reset the has resolved first search flag so that the next time they search,
            // we know it is their first time searching above the min length again.
            _hasResolvedFirstSearchAboveMinLength = false;
          });

          if (_prevSearchQuery.length >= widget.minSearchLength) {
            _paginatedListViewController.clear();
          }
          return;
        }

        _paginatedListViewController.reload();
      },
    );
  }

  _changeFocus(bool isFocused) {
    if (!isFocused) {
      _inputController.clear();
      _paginatedListViewController.clear();

      setState(() {
        _searchQuery = '';
        _prevSearchQuery = '';
        _hasResolvedFirstSearchAboveMinLength = false;
      });
    }

    setState(() {
      _isFocused = isFocused;
    });
  }

  /// After a build finishes, if the size of the list view has changed, we need to check if the
  /// list view has changed from not being expanded to expanded or vice versa in order to decide
  /// whether to show the border between the input and the list view
  _updateListViewBorderAfterBuild() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final listViewHeight = _listViewKey.currentContext!.size!.height;

      final _isExpandedDirty = listViewHeight > 0 && !_isExpanded ||
          listViewHeight == 0 && _isExpanded;

      if (_isExpandedDirty) {
        setState(() {
          _isExpanded = listViewHeight > 0;
        });
      }
    });
  }

  @override
  build(context) {
    _updateListViewBorderAfterBuild();

    return FocusScope(
      child: Focus(
        onFocusChange: (isFocused) {
          if (mounted) {
            _changeFocus(isFocused);
          }
        },
        child: Container(
          child: Column(
            children: [
              FocusScope(
                child: Focus(
                  onFocusChange: (isFocused) {
                    if (mounted) {
                      _changeFocus(isFocused);
                    }
                  },
                  child: TextFormField(
                    controller: _inputController,
                    onFieldSubmitted: (searchQuery) {
                      if (widget.onSubmit != null && _topItem != null) {
                        widget.onSubmit!(
                          item: _topItem!,
                          searchQuery: searchQuery,
                        );
                      }
                    },
                    autofocus: widget.autoFocus,
                    onChanged: (value) {
                      _debouncedSearchSubject.add(value);
                    },
                    style: resolveInputStyleStateProperty(
                      inputStyleState: widget.inputStyleState,
                      inputStyle: widget.inputStyle,
                      states: _searchBarStates,
                    ),
                    decoration: resolveInputDecorationStateProperty(
                      inputDecorationState: widget.inputDecorationState,
                      inputDecoration: widget.inputDecoration,
                      states: _searchBarStates,
                      hintText: widget.hintText,
                    ),
                  ),
                ),
              ),
              resolveSpacerStateProperty(
                context: context,
                states: _searchBarStates,
                isExpanded: _isExpanded,
                spacerBuilder: widget.spacerBuilder,
                spacerBuilderState: widget.spacerBuilderState,
              ),
              ConditionalWrapper(
                condition: widget.maxHeight != null,
                wrapperBuilder: (child) {
                  return LimitedBox(
                    maxHeight: widget.maxHeight!,
                    child: child,
                  );
                },
                child: AnimatedSize(
                  curve: Curves.decelerate,
                  duration: widget.resizeDuration!,
                  child: EndlessPaginationListView<T>(
                    key: _listViewKey,
                    initialLoad: false,
                    controller: _paginatedListViewController,
                    paginationDelegate: _paginationDelegate,
                    padding: widget.padding,
                    itemPadding: widget.itemPadding,
                    onStateChange: (listStates) {
                      final updatedSearchBarStates = resolveSearchStates(
                        listStates: listStates,
                        isFocused: _isFocused,
                      );

                      // The first search above the min search length should not show the empty
                      // state while it's loading. We record once we've finished the first search
                      // so that subsequent searches can know to show the empty state.
                      if (!_hasResolvedFirstSearchAboveMinLength &&
                          _searchQuery.length >= widget.minSearchLength &&
                          _searchBarStates
                              .contains(PaginatedSearchBarState.searching) &&
                          !updatedSearchBarStates
                              .contains(PaginatedSearchBarState.searching)) {
                        _hasResolvedFirstSearchAboveMinLength = true;
                      }

                      setState(() {
                        _searchBarStates = updatedSearchBarStates;
                      });
                    },
                    loadMore: (pageIndex) async {
                      if (pageIndex == 0) {
                        setState(() {
                          _topItem = null;
                        });
                      }
                      final result = await widget.onSearch(
                        searchQuery: _searchQuery,
                        pageIndex: pageIndex,
                        pageSize: _paginationDelegate.pageSize,
                      );

                      return result;
                    },
                    headerBuilderState: resolveHeaderStateProperty(
                      headerBuilder: widget.headerBuilder,
                      headerBuilderState: widget.headerBuilderState,
                      searchBarStates: _searchBarStates,
                    ),
                    itemBuilder: (
                      context, {
                      required item,
                      required index,
                      required totalItems,
                    }) {
                      if (index == 0) {
                        // Record the first result in the list for when the user hits enter
                        _topItem = item;
                      }

                      return widget.itemBuilder(
                        context,
                        item: item,
                        index: index,
                      );
                    },
                    emptyBuilderState: resolveEmptyStateProperty(
                      emptyBuilderState: widget.emptyBuilderState,
                      emptyBuilder: widget.emptyBuilder,
                      placeholderBuilder: widget.placeholderBuilder,
                      placeholderBuilderState: widget.placeholderBuilderState,
                      searchBarStates: _searchBarStates,
                      hasResolvedFirstSearchAboveMinLength:
                          _hasResolvedFirstSearchAboveMinLength,
                    ),
                    loadingBuilderState: resolveLoadingStateProperty(
                      loadingBuilderState: widget.loadingBuilderState,
                      loadingBuilder: widget.loadingBuilder,
                      searchBarStates: _searchBarStates,
                    ),
                    footerBuilderState: resolveFooterStateProperty(
                      footerBuilder: widget.footerBuilder,
                      footerBuilderState: widget.footerBuilderState,
                      searchBarStates: _searchBarStates,
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: resolveContainerStyleStateProperty(
            containerDecorationState: widget.containerDecorationState,
            containerDecoration: widget.containerDecoration,
            states: _searchBarStates,
          ),
        ),
      ),
    );
  }
}
