import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'secret.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:yaml/yaml.dart' as yaml;
import 'package:http/http.dart' as http;
import 'base.dart';
import 'library.dart' show Config;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new AuthCommand())
// ..run(args);

class AuthCommand extends BaseCommand {
  final name = "auth";
  final description = "Authenticate user using OAuth2 flow.";

  AuthCommand(String configPath) : super(configPath);

  Future run() async {
    var credUtil = new Credentials(credentialsPath);
    var secret = new Secret.from(secretPath);
    var scopes = [
      "email",
      "profile",
    ];
    var config = new Config(configPath);
    var scopesToAdd = config.libraries.keys
    .where((String libraryName) => config.getScopes(libraryName).isNotEmpty)
    .map((String libraryName) => config.getScopes(libraryName));

    scopesToAdd.forEach((List<String> libraryScopes) => scopes.addAll(libraryScopes));
    var clientId = await secret.clientId;
    var clientSecret = await secret.clientSecret;
    var id = new auth.ClientId(clientId, clientSecret);
    var client = new http.Client();
    var cred = await auth.obtainAccessCredentialsViaUserConsent(
        id, scopes, client, prompt);
    await credUtil.save(cred);
    client.close();
  }
}

void prompt(String url) {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");
}
