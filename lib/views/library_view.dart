import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/library_view_model.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library'),
      ),
      body: Consumer<LibraryViewModel>(
        builder: (BuildContext context, LibraryViewModel provider, _) {
          return Stack(
            children: [
              if (provider.isLoading) const LinearProgressIndicator(),
              ListView(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          if (_searchController.text.isEmpty) {
                            return;
                          }
                          provider.getBooks(_searchController.text);
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  if (!provider.isLoading)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.bookList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final book = provider.bookList[index];
                        return ListTile(
                          title: Text('${book['volumeInfo']['title']??'No title'}'),
                          subtitle: Text('${book['volumeInfo']['subtitle']??'No subtitle'}'),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
