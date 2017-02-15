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
// import 'reflect.dart' as reflect;
import 'checks.dart' as checks;
import 'dart:mirrors';
import 'dart:isolate';

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new AuthCommand())
// ..run(args);

class InstallCommand extends BaseCommand {
  final name = "library";
  final description = "Manage api libraries.";
  InstallCommand(String configPath) : super(configPath);

  Future run() async {
  }
}
