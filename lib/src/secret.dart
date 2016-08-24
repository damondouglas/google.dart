library google.secret;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gnupg/gnupg.dart' as gnupg;

final credPath = '.credentials';

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

class Credentials {
  String path;
  Credentials(this.path);
  Future save(auth.AccessToken token) {

  	var data = {
  		'type': token.type,
  		'data': token.data,
  		'expiry': token.expiry.millisecondsSinceEpoch
  	};

  	var dataStr = JSON.encode(data);
  	var credFile = new File(path);
  	return credFile.writeAsString(dataStr);
  }
}

Future<String> _encrypt(String data) {
  var command = new gnupg.EncryptCommand();
  return command.encrypt(data);
}

Future<String> _decrypt(String data) {
  var command = new gnupg.DecryptCommand();
  return command.decrypt(data);
}
