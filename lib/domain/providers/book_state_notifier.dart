import 'package:escribo_desafio_2/data/local/book_database_repository.dart';
import 'package:escribo_desafio_2/data/remote/book_service_repository.dart';
import 'package:flutter/material.dart';
import '../models/book_model.dart';

class BookStateNotifier with ChangeNotifier  {
  BookStateNotifier({required this.bookServiceRepository, required this.bookDatabaseRepository});

  final BookServiceRepository bookServiceRepository;
  final BookDatabaseRepository bookDatabaseRepository;

  List<BookModel> _books = [];

  List<BookModel> get books => _books;

  void getBooks() async {
    List<BookModel> booksFromApi = await bookServiceRepository.getBooks();
    Map<int, bool> favoriteStatuses = await bookDatabaseRepository.getFavoriteStatuses();

    for (var book in booksFromApi) {
      book.isFavorite = favoriteStatuses[book.id] ?? false;
    }

    _books = booksFromApi;
    notifyListeners();
  }

  Future<String> downloadBook(String url, int bookId) {
    return bookServiceRepository.downloadBook(url, bookId);
  }

  void toggleFavorite(int bookId) async {
    for (var book in _books) {
      if (book.id == bookId) {
        bool newFavoriteStatus = !book.isFavorite;
        await bookDatabaseRepository.toggleFavorite(bookId, newFavoriteStatus);
        book.isFavorite = newFavoriteStatus;
        break;
      }
    }
    notifyListeners();
  }

  List<BookModel> get favoriteBooks => _books.where((book) => book.isFavorite).toList();
}
