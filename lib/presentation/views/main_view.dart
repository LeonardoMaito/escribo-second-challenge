import 'package:escribo_desafio_2/domain/providers/book_state_notifier.dart';
import 'package:escribo_desafio_2/presentation/widgets/grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
    final bookNotifier = Provider.of<BookStateNotifier>(context, listen: false);
    bookNotifier.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    final bookNotifier = Provider.of<BookStateNotifier>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Center(child: Text( 'Estante Virtual', style: TextStyle(color: Colors.black),)),
          bottom: const TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(fontSize: 20),
            tabs: [Tab(text: 'Livros'), Tab(text: 'Favoritos')],
          ),
        ),
        body: TabBarView(
          children: [buildLibrary(bookNotifier),
            buildFavoriteLibrary(bookNotifier)],
        ),
      ),
    );
  }

  Widget buildLibrary(BookStateNotifier bookNotifier) {
    final books = bookNotifier.books;
    return bookGridWidget(
      books: books,
      bookNotifier: bookNotifier,
    );
  }

  Widget buildFavoriteLibrary(BookStateNotifier bookNotifier) {
    final favoriteBooks = bookNotifier.favoriteBooks;

    return bookGridWidget(
      books: favoriteBooks,
      bookNotifier: bookNotifier,
    );
  }
}
