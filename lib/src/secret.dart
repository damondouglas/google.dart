library google.secret;
import 'dart:io';
import 'dart:convert';

class Secret {
  String clientId;
  String clientSecret;

  Secret.from(String relativePath) {
    var f = new File(relativePath);
    assert(f.existsSync());
    var secretData = f.readAsStringSync();
    var secret = JSON.decode(secretData);
    var installed = secret['installed'];
    clientId = installed['client_id'];
    clientSecret = installed['client_secret'];
  }
}
