library paginated_search_bar;

import 'package:endless/endless.dart';
import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar_state_property.dart';
import 'package:paginated_search_bar/state_properties/list_view.dart';
import 'package:paginated_search_bar/state_properties/spacer.dart';
import 'package:paginated_search_bar/state_properties/styles.dart';
import 'package:paginated_search_bar/utils/paginated_search_state.dart';
import 'package:paginated_search_bar/widgets/conditional_wrapper.dart';
import 'package:rxdart/rxdart.dart';

class PaginatedSearchBar<T> extends StatefulWidget {
  final Duration? resizeDuration;
  final Duration? debounceDuration;
  final String? hintText;
  final int minSearchLength;
  final Future<List<T>> Function({
    required String searchQuery,
    required int pageIndex,
    required int pageSize,
  }) onSearch;
  final double? maxHeight;
  final EndlessPaginationController<T>? listController;
  final EndlessPaginationDelegate? paginationDelegate;
  final TextEditingController? inputController;
  final bool autoFocus;
  final EdgeInsets? itemPadding;
  final EdgeInsets? padding;
  final void Function({T item, String searchQuery})? onSubmit;

  final TextStyle? inputStyle;
  final PaginatedSearchBarStyleStateProperty<TextStyle>? inputStyleState;

  final InputDecoration? inputDecoration;
  final PaginatedSearchBarStyleStateProperty<InputDecoration>?
      inputDecorationState;

  final BoxDecoration? containerDecoration;
  final PaginatedSearchBarStyleStateProperty<BoxDecoration>?
      containerDecorationState;

  final Widget Function(BuildContext context)? spacerBuilder;
  final PaginatedSearchBarBuilderStateProperty? spacerBuilderState;

  final Widget Function(BuildContext context)? headerBuilder;
  final PaginatedSearchBarBuilderStateProperty? headerBuilderState;

  final Widget Function(
    BuildContext context, {
    required T item,
    required int index,
  }) itemBuilder;

  final Widget Function(BuildContext context)? emptyBuilder;
  final PaginatedSearchBarBuilderStateProperty? emptyBuilderState;

  final Widget Function(BuildContext context)? placeholderBuilder;
  final PaginatedSearchBarBuilderStateProperty? placeholderBuilderState;

  final Widget Function(BuildContext context)? loadingBuilder;
  final PaginatedSearchBarBuilderStateProperty? loadingBuilderState;

  final Widget Function(BuildContext context)? footerBuilder;
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
    this.itemPadding,
    this.padding,
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
    this.debounceDuration,
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
  bool _isSearching = false;
  bool _isFocused = false;
  bool _isExpanded = false;
  bool _hasResolvedFirstSearchAboveMinLength = false;
  Set<EndlessState> _listStates = {EndlessState.empty};

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
            ? widget.debounceDuration ?? const Duration(milliseconds: 200)
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

        _isSearching = true;

        _paginatedListViewController.reload();
      },
    );
  }

  Widget? _emptyBuilder(BuildContext context) {
    if (widget.emptyBuilder != null) {
      return IntrinsicHeight(
        child: widget.emptyBuilder!(
          context,
        ),
      );
    }
  }

  Widget? _placeholderBuilder(BuildContext context) {
    if (widget.placeholderBuilder != null) {
      return IntrinsicHeight(
        child: widget.placeholderBuilder!(
          context,
        ),
      );
    }
  }

  _changeFocus(bool isFocused) {
    if (!isFocused) {
      _inputController.clear();
      _paginatedListViewController.clear();

      setState(() {
        _searchQuery = '';
        _prevSearchQuery = '';
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

    final states = resolveSearchStates(
      listStates: _listStates,
      isSearching: _isSearching,
      isFocused: _isFocused,
      isExpanded: _isExpanded,
    );

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
                      states: states,
                    ),
                    decoration: resolveInputDecorationStateProperty(
                      inputDecorationState: widget.inputDecorationState,
                      inputDecoration: widget.inputDecoration,
                      states: states,
                      hintText: widget.hintText,
                    ),
                  ),
                ),
              ),
              resolveSpacerStateProperty(
                context: context,
                states: states,
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
                    padding: widget.padding ?? EdgeInsets.zero,
                    itemPadding: widget.itemPadding ??
                        const EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                        ),
                    onStateChange: (listStates) {
                      if (_isSearching &&
                          !listStates.contains(EndlessState.loading)) {
                        _hasResolvedFirstSearchAboveMinLength = true;
                        _isSearching = false;
                      }
                      setState(() {
                        _listStates = listStates;
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
                      states: states,
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
                      emptyBuilder: _emptyBuilder,
                      placeholderBuilder: _placeholderBuilder,
                      placeholderBuilderState: widget.placeholderBuilderState,
                      states: states,
                      hasResolvedFirstSearchAboveMinLength:
                          _hasResolvedFirstSearchAboveMinLength,
                    ),
                    loadingBuilderState: resolveLoadingStateProperty(
                      loadingBuilderState: widget.loadingBuilderState,
                      loadingBuilder: widget.loadingBuilder,
                      states: states,
                    ),
                    footerBuilderState: resolveFooterStateProperty(
                      footerBuilder: widget.footerBuilder,
                      footerBuilderState: widget.footerBuilderState,
                      states: states,
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: resolveContainerStyleStateProperty(
            containerDecorationState: widget.containerDecorationState,
            containerDecoration: widget.containerDecoration,
            states: states,
          ),
        ),
      ),
    );
  }
}
