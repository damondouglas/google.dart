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
		var scopesFile = new File(scopesPath);
		var scopesYaml = yaml.loadYaml(scopesFile.readAsStringSync());
		var keys = scopesYaml.keys.where((key) => key != 'base');
		var scopes = scopesYaml['base'].split(',');
		scopes.addAll(
			keys.map((k) => scopesYaml[k])
			.toList()
		);
		var id = new auth.ClientId(secret.clientId, secret.clientSecret);
		var client = new http.Client();
		var cred = await auth.obtainAccessCredentialsViaUserConsent(id, scopes, client, prompt);
		await credUtil.save(cred);
		client.close();
	}
}

void prompt(String url) {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");
}
