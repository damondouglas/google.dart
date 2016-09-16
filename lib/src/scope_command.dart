import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:async';
import 'base.dart';
import 'secret.dart' as secret;
import 'dart:io';
import 'package:yaml/yaml.dart' as yaml;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new ScopeCommand())
// ..run(args);

class ScopeCommand extends BaseCommand {
	final name = "scope";
	final description = "Manage OAuth scopes.";

	ScopeCommand(String configPath) : super(configPath) {
		addSubcommand(new ListCommand(configPath));
		addSubcommand(new AddCommand(configPath));
	}

	Future run() {

	}
}

class ListCommand extends BaseCommand {
	final name = "list";
	final description = "List authorized scopes.";

	ListCommand(String configPath) : super(configPath);

	Future run() async {
		var credUtil = new secret.Credentials(credentialsPath);
		var cred = await credUtil.load();
		cred.scopes.forEach((s) => print(s));
	}
}

class AddCommand extends BaseCommand {
	final name = "add";
	final description = "Add scope to authorized scopes";
	final usage = "google scope add <scope>";

	AddCommand(String configPath) : super(configPath);

	@override
	printUsage() {
		print("Scope not found.");
		print("Usage:");
		var availableScopes = _loadAvailableScopes();
		var scopeKeys = new List.from(availableScopes.keys.where((key) => key != "base"));
		super.printUsage();
		print("");
		scopeKeys.forEach((key) => print("\t$key: ${availableScopes[key]}"));
		exit(0);
	}

	Future run() async {
		var availableScopes = _loadAvailableScopes();
		var installedScopes = _loadInstalledScopes();
		var scopeKeys = new List.from(
			availableScopes.keys
			.where((key) => !installedScopes.containsKey(key))
		);
		if (argResults.rest.isEmpty) printUsage();

		var scopeKey = argResults.rest.first;
		if (!availableScopes.containsKey(scopeKey)) printUsage();

		var scope = availableScopes[scopeKey];

		var scopesFile = new File(scopesPath);
		var scopesData = scopesFile.readAsStringSync();
		scopesFile.writeAsStringSync("$scopeKey: $scope", mode: FileMode.APPEND);
		print("Run: `google auth` to complete installation.");
	}

	Map _loadAvailableScopes() {
		var availableScopesFile = new File(super.availableScopesPath);
		var availableScopesData = availableScopesFile.readAsStringSync();
		return yaml.loadYaml(availableScopesData);
	}

	Map _loadInstalledScopes() {
		var scopesFile = new File(scopesPath);
		var scopesData = scopesFile.readAsStringSync();
		return yaml.loadYaml(scopesData);
	}
}
