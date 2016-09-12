import 'package:args/args.dart' as args;
import 'base.dart';
import 'dart:async';
import 'secret.dart';
import 'dart:io';
import 'package:yaml/yaml.dart' as yaml;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/people/v1.dart' as people;

class WhoamiCommand extends BaseCommand {
	final name = "whoami";
	final description = "Display authenticated user info.";
	WhoamiCommand(String configPath) : super(configPath);

	Future run() async {
		// var credUtil = new Credentials(credentialsPath);
		// var cred = await credUtil.load();
		// var baseClient = new http.Client();
		// var client = auth.authenticatedClient(baseClient, cred);
		var client = await loadClient(secretPath, credentialsPath);
		var api = new people.PeopleApi(client);
		var p = await api.people.get("people/me");
		var sb = new StringBuffer();

		p.names.forEach((name) => sb.writeln(name.displayName));
		p.emailAddresses.forEach((e) => sb.writeln(e.value));
		p.urls.forEach((u) => sb.writeln(u.value));

		print(sb.toString());
		exit(0);
	}
}
