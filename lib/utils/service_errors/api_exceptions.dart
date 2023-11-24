
class ApiExceptions implements Exception {
  final int statusCode;
  final String message;

  ApiExceptions(this.statusCode) : message = _getMessage(statusCode);

  static String _getMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return "Requisição inválida.";
      case 401:
        return "Não autorizado. Verifique suas credenciais.";
      case 403:
        return "Acesso proibido.";
      case 404:
        return "Recurso não encontrado.";
      case 500:
        return "Erro interno no servidor.";
      case 503:
        return "Serviço indisponível. Tente novamente mais tarde.";
      default:
        return "Ocorreu um erro desconhecido. Código de status: $statusCode";
    }
  }

  @override
  String toString() => 'Erro da API: $message';
}
