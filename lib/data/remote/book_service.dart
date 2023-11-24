
import 'dart:convert';
import 'dart:io';
import 'package:escribo_desafio_2/utils/constants/url.dart';
import 'package:http/http.dart' as http;
import '../../domain/models/book_model.dart';
import '../../domain/models/book_service_interface.dart';
import '../../utils/service_errors/api_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BookService implements BookServiceInterface{

  @override
  Future<List<BookModel>> getBooks() async {
    final response = await http.get(Uri.parse(Constants.baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final List<BookModel> books = (jsonData as List)
          .map((data) => BookModel.fromJson(data))
          .toList();

      return books;
    } else{
      throw ApiExceptions(response.statusCode);
    }
  }

  @override
  Future<String> downloadBook(String url) async {

    final status = await Permission.storage.request();

    if (status.isGranted) {

      Directory? appDocDir = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();

      String path = '${appDocDir!.path}/sample.epub';

      final dio = Dio();

      try {
        final response = await dio.download(
            url,
            path,
            deleteOnError: true,);

        if (response.statusCode == 200) {
          return path; // Retorna o caminho do arquivo
        } else {
          return 'Erro no download: ${response.statusCode}';
        }
      } catch (e) {
        return 'Erro ao tentar baixar o arquivo: $e';
      }
    } else {
      return 'Permissão de armazenamento negada';
    }
  }
}