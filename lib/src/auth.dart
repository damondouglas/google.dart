import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'secret.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:yaml/yaml.dart' as yaml;
import 'package:http/http.dart' as http;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new AuthCommand())
// ..run(args);

final pathToSecret = 'secret.json';

class AuthCommand extends Command {
	final name = "auth";
	final description = "Authenticate user using OAuth2 flow.";

	Future run() async {
		var secret = new Secret.from(pathToSecret);
		var scopesFile = new File('scopes.yaml');
		var scopes = yaml.loadYaml(scopesFile.readAsStringSync());
		var id = new auth.ClientId(secret.clientId, secret.clientSecret);
		var client = new http.Client();
		var cred = await auth.obtainAccessCredentialsViaUserConsent(id, scopes['base'].split(','), client, prompt);
		
		client.close();

	}
}

void prompt(String url) {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");
}
