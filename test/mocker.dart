const emptySearchQuery = 'empty';

class MockItemBatcher {
  String? searchQuery;

  List<MockItem> nextPage({
    required int pageIndex,
    required String searchQuery,
    required int pageSize,
  }) {
    List<MockItem> batch = [];

    if (searchQuery != this.searchQuery) {
      this.searchQuery = searchQuery;
    }

    if (searchQuery == emptySearchQuery) {
      return [];
    }

    for (int i = 0; i < pageSize; i++) {
      batch.add(
        MockItem(
          title: 'Item for $searchQuery ${pageIndex * pageSize + i}',
        ),
      );
    }

    return batch;
  }
}

class MockItem {
  final String title;

  MockItem({required this.title});
}
