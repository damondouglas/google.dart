library google.secret;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gnupg/gnupg.dart' as gnupg;
import 'package:http/http.dart' as http;

final credPath = '.credentials';

class Secret {
  String clientId;
  String clientSecret;

  Secret.from(String path) {
    var f = new File(path);
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
  Future save(auth.AccessCredentials cred) {
    var token = cred.accessToken;
  	var data = {
      'refreshToken': cred.refreshToken,
      'scopes': cred.scopes,
  		'type': token.type,
  		'data': token.data,
  		'expiry': token.expiry.millisecondsSinceEpoch
  	};

  	var dataStr = JSON.encode(data);
  	var credFile = new File(path);
  	return credFile.writeAsString(dataStr);
  }

  Future<auth.AccessCredentials> load() async {
    var credFile = new File(path);
    var dataStr = await credFile.readAsString();
    var data = JSON.decode(dataStr);
    var refreshToken = data['refreshToken'];
    var scopes = data['scopes'];
    var type = data['type'];
    var tokenData = data['data'];
    var expiry = new DateTime.fromMillisecondsSinceEpoch(data['expiry']).toUtc();
    var token = new auth.AccessToken(type, tokenData, expiry);
    var cred = new auth.AccessCredentials(token, refreshToken, scopes);
    return cred;
  }
}

Future<auth.AutoRefreshingAuthClient> loadClient(String pathToSecret, String pathToCredentials) async {
  var secret = new Secret.from(pathToSecret);
  var cred = new Credentials(pathToCredentials);
  var id = new auth.ClientId(secret.clientId, secret.clientSecret);
  var accessCredentials = await cred.load();
  var baseClient = new http.Client();
  var client = auth.autoRefreshingClient(id, accessCredentials, baseClient);
  client.credentialUpdates.listen((auth.AccessCredentials refreshedCredentials) => cred.save(refreshedCredentials));
  return client;
}

Future<String> _encrypt(String data) {
  var command = new gnupg.EncryptCommand();
  return command.encrypt(data);
}

Future<String> _decrypt(String data) {
  var command = new gnupg.DecryptCommand();
  return command.decrypt(data);
}
