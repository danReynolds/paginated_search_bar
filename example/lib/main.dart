import 'package:flutter/material.dart';
import 'package:paginated_search_bar/paginated_search_bar.dart';
import 'package:endless/endless.dart';

class ExampleItem {
  final String title;

  ExampleItem({
    required this.title,
  });
}

class ExampleItemPager {
  int pageIndex = 0;
  final int pageSize;

  ExampleItemPager({
    this.pageSize = 20,
  });

  List<ExampleItem> nextBatch() {
    List<ExampleItem> batch = [];

    for (int i = 0; i < pageSize; i++) {
      batch.add(ExampleItem(title: 'Item ${pageIndex * pageSize + i}'));
    }

    pageIndex += 1;

    return batch;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    ExampleItemPager pager = ExampleItemPager();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 200),
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 600,
              child: PaginatedSearchBar<ExampleItem>(
                maxHeight: 300,
                emptyBuilder: (context) {
                  return const Text('No items');
                },
                placeholderBuilder: (context) {
                  return const Text("I'm a placeholder!");
                },
                paginationDelegate: EndlessPaginationDelegate(
                  pageSize: 20,
                  maxPages: 3,
                ),
                onSearch: ({
                  required pageIndex,
                  required pageSize,
                  required searchQuery,
                }) async {
                  return Future.delayed(const Duration(milliseconds: 1300), () {
                    if (searchQuery == "empty") {
                      return [];
                    }

                    if (pageIndex == 0) {
                      pager = ExampleItemPager();
                    }

                    return pager.nextBatch();
                  });
                },
                itemBuilder: (
                  context, {
                  required item,
                  required index,
                }) {
                  return Text(item.title);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
