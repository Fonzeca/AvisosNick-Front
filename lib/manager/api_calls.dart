import 'package:http/http.dart' as http;
import 'package:nick_tecnologia_notices/manager/mindia_http_client.dart';

class ServidorRest {
  final client = MindiaHttpClient(http.Client());
  final String IpServer = "http://vps-1791261-x.dattaweb.com";
  final String Port = "45589";


  Future<void> login(String email, String password) async {
    String endpoint = "/login";
    String requestParam = "?email=" + email + "&password=" + password;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    MindiaHttpClient.setToken(response.body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  }

  Future<String> loginWithGoogle(String idToken) async {
    String endpoint = "/loginWithGoogle";
    String requestParam = "?idToken=" + idToken;

    var response = await http.post(IpServer + ":" + Port + endpoint + requestParam);
    MindiaHttpClient.setToken(response.body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    return response.body;
  }

  void checkNotices(){

  }

}