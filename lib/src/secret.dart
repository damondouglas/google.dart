library google.secret;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'crypt.dart' as crypt;

final credPath = '.credentials';

class Secret {
  Future<String> get clientId => _clientIdCompleter.future;
  Future<String> get clientSecret => _clientSecretCompleter.future;
  var _clientIdCompleter = new Completer();
  var _clientSecretCompleter = new Completer();

  Secret.from(String path) {
    var f = new File(path);
    assert(f.existsSync());
    // var secretData = f.readAsStringSync();
    _load(f).then((secretData) {
      var secret = JSON.decode(secretData);
      var installed = secret['installed'];
      _clientIdCompleter.complete(installed['client_id']);
      _clientSecretCompleter.complete(installed['client_secret']);
    });
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
    return _save(dataStr, credFile);
  }

  Future<auth.AccessCredentials> load() async {
    var credFile = new File(path);
    var dataStr = await _load(credFile);
    var data = JSON.decode(dataStr);
    var refreshToken = data['refreshToken'];
    var scopes = data['scopes'];
    var type = data['type'];
    var tokenData = data['data'];
    var expiry =
        new DateTime.fromMillisecondsSinceEpoch(data['expiry']).toUtc();
    var token = new auth.AccessToken(type, tokenData, expiry);
    var cred = new auth.AccessCredentials(token, refreshToken, scopes);
    return cred;
  }
}

Future _save(String data, File file) => new Future(() async {
      // var encryptedData = data;
      var encryptedData = await crypt.encrypt(data);
      return file.writeAsString(encryptedData);
    });

Future<String> _load(File file) => new Future(() async {
      var encryptedData = await file.readAsString();
      // var data = encryptedData;
      var data = await crypt.decrypt(encryptedData);
      return data;
    });

Future<auth.AutoRefreshingAuthClient> loadClient(
    String pathToSecret, String pathToCredentials) async {
  var secret = new Secret.from(pathToSecret);
  var cred = new Credentials(pathToCredentials);
  var clientId = await secret.clientId;
  var clientSecret = await secret.clientSecret;
  var id = new auth.ClientId(clientId, clientSecret);
  var accessCredentials = await cred.load();
  var baseClient = new http.Client();
  var client = auth.autoRefreshingClient(id, accessCredentials, baseClient);
  client.credentialUpdates.listen(
      (auth.AccessCredentials refreshedCredentials) =>
          cred.save(refreshedCredentials));
  return client;
}
