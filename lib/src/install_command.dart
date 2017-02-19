import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'secret.dart';
import 'library.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:yaml/yaml.dart' as yaml;
import 'package:http/http.dart' as http;
import 'base.dart';
import 'reflect.dart' as reflect;
// import 'dart:mirrors';
import 'dart:isolate';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart' as yaml;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new AuthCommand())
// ..run(args);

final _PACKAGES = './.packages';
final _COMMAND_NAME = 'library';
final _URI_BASE = 'package:googleapis';

class InstallCommand extends BaseCommand {
  final name = _COMMAND_NAME;
  final description = "Manage api libraries.";
  InstallCommand(String configPath) : super(configPath) {
    addSubcommand(new _AvailableCommand(configPath));
    addSubcommand(new _AddCommand(configPath));
  }

  Future run() async {}
}

class _AddCommand extends BaseCommand {
  final name = "add";
  final description = "Make library available for use.";
  _AddCommand(String configPath) : super(configPath);

  Future run() async {
    var rest = this.argResults.rest;

    if (rest.isEmpty) {
      printUsage();
      exit(1);
    }

    var libraryName = rest.first;
    var config = new Config(configPath);
    if (config.libraries.keys.contains(libraryName)) {
      print("$libraryName already configured:");
      print(config.libraries[libraryName]);
      exit(1);
    }

    var availableLibraries = await getAvailableLibraries();
    if (!availableLibraries.contains(libraryName)) {
      print("$libraryName is not available.");
      print('');
      print("Run:");
      print("\$ google $_COMMAND_NAME available");
      print("for a list of available libraries.");
      exit(1);
    }

    var dirList = await getLibraryDirs();
    var libraryDir = dirList.firstWhere((Directory dir) => path.basename(dir.path) == libraryName);
    var versionFileNames = await getVersions(libraryDir);

    var vFileName = versionFileNames.last;
    var libUri = "$_URI_BASE/$libraryName/$vFileName";
    config.addUri(libraryName, libUri);
    config.save();
    print("Saved $libraryName to ${config.configFile.path} pointing to $libUri");
  }

  @override
  printUsage() {
    print("Usage:");
    print("google $_COMMAND_NAME $name <library name>");
    print('');
    print("Run:");
    print("\$ google $_COMMAND_NAME available");
    print("for a list of available libraries.");
  }
}

class _AvailableCommand extends BaseCommand {
  final name = "available";
  final description = "Lists available apis to install.";
  _AvailableCommand(String configPath) : super(configPath);

  Future run() async {
    var dirs = await getAvailableLibraries();
    dirs
    .forEach((String name) => print(name));
  }
}
