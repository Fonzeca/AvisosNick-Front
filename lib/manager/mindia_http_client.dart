import 'package:http/http.dart' as http;

class MindiaHttpClient extends http.BaseClient {
  static String _tokenNick = "";
  String authorization = "Bearer ";
  final http.Client _inner;

  MindiaHttpClient(this._inner);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = authorization + _tokenNick;
    return _inner.send(request);
  }

  static void setToken(String token){
    _tokenNick = token;
  }
}