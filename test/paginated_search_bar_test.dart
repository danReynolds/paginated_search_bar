import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import 'package:paginated_search_bar/paginated_search_bar.dart';

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
}
