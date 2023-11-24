
import 'book_model.dart';

abstract class BookServiceInterface{
  Future<List<BookModel>> getBooks();
  Future<String> downloadBook(String url);
}

abstract class BookServiceRepositoryInterface {
  Future<List<BookModel>> getBooks();
  Future<String> downloadBook(String url, int bookId);
}