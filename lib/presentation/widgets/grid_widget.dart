import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import '../../domain/models/book_model.dart';
import '../../domain/providers/book_state_notifier.dart';

Widget bookGridWidget({
  required List<BookModel> books,
  required BookStateNotifier bookNotifier,
})  {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: GridView.builder(
      padding: const EdgeInsets.only(left: 12, right: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return GridTile(
          header: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  size: 35,
                  book.isFavorite ? Icons.bookmark : Icons.bookmark_add,
                  color: book.isFavorite ? Colors.amber : Colors.grey,
                ),
                onPressed: () {
                  bookNotifier.toggleFavorite(book.id);
                },
              ),
            ],
          ),
          child: Card(
            elevation: 8,
            color: Colors.grey[300],
            shadowColor: Colors.amber,
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: InkWell(
                      onTap:  () async {
                        if(context.mounted){
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Abrindo arquivo..',style: TextStyle(color: Colors.black),),duration: Duration(seconds: 1), backgroundColor: Colors.amber));
                        }
                        final path = await bookNotifier.downloadBook(book.downloadUrl, book.id);

                        VocsyEpub.open(path);
                      },
                      child: Image.network(
                        book.coverUrl,
                        loadingBuilder:
                            (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                              child: Text('Erro ao carregar imagem'));
                        },
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                  child: Column(
                    children: [
                      Text(
                        book.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        book.author,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );

}

