import 'package:http/http.dart' as http;
import 'dart:convert';

DateTime _getTokenExpiration(String token) {
  var parts = token.split('.');
  var payload = parts[1];
  var decoded = null;
  var claims = jsonDecode(decoded);
  return DateTime.fromMillisecondsSinceEpoch((claims['exp'] as int) * 1000);
}

class Token {
  final String token, refreshToken;

  Token(this.token, this.refreshToken);

  bool get valid => token != null && refreshToken != null;

  Future<Token> refreshed() async {
    var expiresAt = _getTokenExpiration(token);
    if (expiresAt.isAfter(DateTime.now())) {
      return this;
    }
    return await Operator.refresh(refreshToken);
  }
}

class Operator {
  static Future<String> init(String phone) async {
    var config = await Config.remote();
    String operatorUrl = config['operatorUrl'];

    var resp = await http.post();
  }
}
