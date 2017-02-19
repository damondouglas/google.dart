import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'dart:async';
import 'base.dart';
import 'secret.dart' as secret;
import 'dart:io';
import 'package:yaml/yaml.dart' as yaml;
import 'library.dart';
import 'reflect.dart' show Scope;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new ScopeCommand())
// ..run(args);

class ScopeCommand extends BaseCommand {
  final name = "scope";
  final description = "Manage OAuth scopes.";

  ScopeCommand(String configPath) : super(configPath) {
    addSubcommand(new _ListCommand(configPath));
    addSubcommand(new _SetCommand(configPath));
    addSubcommand(new _AvailableCommand(configPath));
  }

  Future run() {}
}

class _ListCommand extends BaseCommand {
  final name = "list";
  final description = "List authorized scopes.";

  _ListCommand(String configPath) : super(configPath);

  Future run() async {
    var config = new Config(configPath);
    config.libraries.keys.forEach((String libraryName) {
      var scopes = config.getScopes(libraryName);
      print("$libraryName: $scopes");
    });
  }
}

class _SetCommand extends BaseCommand {
  final name = "set";
  final description = "Add scope to authorized scopes";
  final usage = "google scope add <scope>";
  final arguments = ['libraryName', 'scopeName'];

  _SetCommand(String configPath) : super(configPath);

  Future run() async {
    var rest = argResults.rest;
    if (rest.length != arguments.length) {
      printUsage();
      print("arguments: $arguments");
      exit(1);
    }

    var libraryName = rest.first;
    var scopeName = rest.last;
    var config = new Config(configPath);
    var libraryUri = config[libraryName];
    var scope = new Scope(libraryUri);
    var scopeUri = scope.available[scopeName];
    config.setScopes(libraryName, [scopeUri]);
    config.save();
    print("$scopeName: $scopeUri saved to $libraryName");
  }

}

class _AvailableCommand extends BaseCommand {
  final name = "available";
  final description = "List available scopes";
  final arguments = ['libraryName'];

  _AvailableCommand(String configPath) : super(configPath);

  Future run() async {
    var rest = argResults.rest;
    if (rest.isEmpty) {
      printUsage();
      print("arguments: $arguments");
      exit(1);
    }

    var libraryName = rest.first;
    var config = new Config(configPath);
    var libraryUri = config[libraryName];
    var scope = new Scope(libraryUri);
    scope.available.forEach((k, v) => print("$k: $v"));
  }
}
