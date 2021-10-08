import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:paginated_search_bar/paginated_search_bar.dart';

import 'mocker.dart';

// The default typing debounce duration is 200ms
const debounceDuration = Duration(milliseconds: 200);

void main() {
  testGoldens(
    'Initial state',
    (WidgetTester tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Initial state',
          SizedBox(
            width: 600,
            child: PaginatedSearchBar(
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async =>
                  [],
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Container();
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'initial', customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Initial state with placeholder',
    (WidgetTester tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Initial state with placeholder',
          SizedBox(
            width: 600,
            child: PaginatedSearchBar(
              placeholderBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("I'm a placeholder!"),
                );
              },
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async =>
                  [],
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Container();
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'initial_with_placeholder',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Initial state with header and footer',
    (WidgetTester tester) async {
      await loadAppFonts();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Initial state with header and footer',
          SizedBox(
            width: 600,
            child: PaginatedSearchBar(
              headerBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("I'm a header!"),
                );
              },
              placeholderBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("I'm a placeholder!"),
                );
              },
              footerBuilder: (context) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text("I'm a footer!"),
                );
              },
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async =>
                  [],
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Container();
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await screenMatchesGolden(tester, 'initial_with_header_and_footer',
          customPump: (widget) {
        return widget.pump(Duration.zero);
      });
    },
  );

  testGoldens(
    'Search below min length',
    (WidgetTester tester) async {
      await loadAppFonts();

      final mocker = MockItemBatcher();

      final builder = GoldenBuilder.column()
        ..addScenario(
          'Search below min length',
          SizedBox(
            width: 600,
            child: PaginatedSearchBar(
              minSearchLength: 4,
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async =>
                  mocker.nextPage(
                pageIndex: pageIndex,
                pageSize: pageSize,
                searchQuery: searchQuery,
              ),
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Container();
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await tester.enterText(find.byType(TextFormField), 'The');

      await screenMatchesGolden(tester, 'search_below_min_length',
          customPump: (widget) {
        return widget.pump(debounceDuration);
      });
    },
  );

  group('Search above min length', () {
    testGoldens(
      'with results',
      (WidgetTester tester) async {
        await loadAppFonts();

        final mocker = MockItemBatcher();

        final builder = GoldenBuilder.column()
          ..addScenario(
            'with results',
            SizedBox(
              width: 600,
              child: PaginatedSearchBar<MockItem>(
                minSearchLength: 3,
                placeholderBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("I'm a placeholder!"),
                  );
                },
                onSearch: ({
                  required pageIndex,
                  required pageSize,
                  required searchQuery,
                }) async =>
                    mocker.nextPage(
                  pageIndex: pageIndex,
                  pageSize: pageSize,
                  searchQuery: searchQuery,
                ),
                itemBuilder: (
                  context, {
                  required item,
                  required index,
                }) {
                  return Text(item.title);
                },
              ),
            ),
          );

        await tester.pumpWidgetBuilder(builder.build());
        await tester.enterText(find.byType(TextFormField), 'The');
        await tester.pump(debounceDuration);

        await screenMatchesGolden(
            tester, 'search_above_min_length_with_results');
      },
    );

    testGoldens(
      'empty results',
      (WidgetTester tester) async {
        await loadAppFonts();

        final mocker = MockItemBatcher();

        final builder = GoldenBuilder.column()
          ..addScenario(
            'empty results',
            SizedBox(
              width: 600,
              child: PaginatedSearchBar<MockItem>(
                minSearchLength: 3,
                placeholderBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("I'm a placeholder!"),
                  );
                },
                emptyBuilder: (context) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('nothing to see here'),
                  );
                },
                onSearch: ({
                  required pageIndex,
                  required pageSize,
                  required searchQuery,
                }) async =>
                    mocker.nextPage(
                  pageIndex: pageIndex,
                  pageSize: pageSize,
                  searchQuery: searchQuery,
                ),
                itemBuilder: (
                  context, {
                  required item,
                  required index,
                }) {
                  return Text(item.title);
                },
              ),
            ),
          );

        await tester.pumpWidgetBuilder(builder.build());
        await tester.enterText(find.byType(TextFormField), 'empty');
        await tester.pump(debounceDuration);

        await screenMatchesGolden(
          tester,
          'search_above_min_length_empty_results',
        );
      },
    );
  });

  testGoldens(
    'inline loading',
    (WidgetTester tester) async {
      await loadAppFonts();

      const searchDuration = Duration(seconds: 2);

      final builder = GoldenBuilder.column()
        ..addScenario(
          'inline loading',
          SizedBox(
            width: 600,
            child: PaginatedSearchBar<MockItem>(
              minSearchLength: 3,
              onSearch: ({
                required pageIndex,
                required pageSize,
                required searchQuery,
              }) async =>
                  Future.delayed(searchDuration, () => []),
              itemBuilder: (
                context, {
                required item,
                required index,
              }) {
                return Text(item.title);
              },
            ),
          ),
        );

      await tester.pumpWidgetBuilder(builder.build());
      await tester.enterText(find.byType(TextFormField), 'The');
      await tester.pump(searchDuration);

      await screenMatchesGolden(tester, 'inline_loading', customPump: (widget) {
        return widget.pump(searchDuration);
      });
    },
  );
}
