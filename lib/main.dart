import 'package:escribo_desafio_2/data/local/book_database_repository.dart';
import 'package:escribo_desafio_2/domain/providers/book_state_notifier.dart';
import 'package:escribo_desafio_2/presentation/views/main_view.dart';
import 'package:escribo_desafio_2/utils/configs/epub_reader_configuration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/remote/book_service.dart';
import 'data/remote/book_service_repository.dart';

void main() async {
  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => BookService()),
        Provider(create: (_) => BookDatabaseRepository()),

        Provider(
          create: (context) => BookServiceRepository(
            bookService: Provider.of<BookService>(context, listen: false),
            bookDatabaseRepository: Provider.of<BookDatabaseRepository>(context, listen: false)
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => BookStateNotifier(
            bookServiceRepository:
                Provider.of<BookServiceRepository>(context, listen: false),
                bookDatabaseRepository: Provider.of<BookDatabaseRepository>(context, listen: false)
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,

        home: Builder(
          builder: (context) {
            EpubReaderManager.setConfig(context);
            return const MainView();
          },
        ),
      ),
    ),
  );
}
