
class BookModel {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  bool isFavorite;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.isFavorite = false
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverUrl': coverUrl,
      'downloadUrl': downloadUrl,
      'isFavorite': isFavorite ? 1 : 0, // Armazenando como inteiro para SQLite
    };
  }

  factory BookModel.fromJson(Map<String, dynamic> json){
    return BookModel(id: json['id'],
        title: json['title'],
        author: json['author'],
        coverUrl: json['cover_url'],
        downloadUrl: json['download_url']);
  }

  void toggleFavorite() {
    isFavorite = !isFavorite;
  }
}