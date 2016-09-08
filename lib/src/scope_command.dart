import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:async';
import 'base.dart';
import 'secret.dart' as secret;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new ScopeCommand())
// ..run(args);

class ScopeCommand extends BaseCommand {
	final name = "scope";
	final description = "Manage OAuth scopes.";

	ScopeCommand(String configPath) : super(configPath) {
		addSubcommand(new ListCommand(configPath));
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

	AddCommand(String configPath) : super(configPath);

	Future run() async {
		
	}
}
