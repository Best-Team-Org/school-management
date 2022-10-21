import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
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
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 125,
                              child: InkWell(
                                child: Card(
                                  color: Theme.of(context).cardColor,
                                  elevation: 10.0,
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                        margin: const EdgeInsets.all(8.0),
                                        width: 100,
                                        height: 125,
                                        child: Hero(
                                          tag: index,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(5.0),
                                            child: Image.network(
                                              book['volumeInfo']['imageLinks']['smallThumbnail'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.5,
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book['volumeInfo']['title']??'No title',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.headline6,
                                            ),
                                            const SizedBox(
                                              height: 10.0,
                                            ),
                                            Text(
                                              book['volumeInfo']['subtitle']??'No subtitle',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: Theme.of(context).textTheme.bodyText2,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text('${book['volumeInfo']['pageCount']??'00'} page'),
                                              Text(book['volumeInfo']['language']??'xx'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async{
                                  Uri url = Uri.parse(book['volumeInfo']['previewLink']);
                                  if (!await launchUrl(url)) {
                                  throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
