import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:io';
import 'base.dart';

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new InitCommand())
// ..run(args);

class InitCommand extends BaseCommand {
  final name = "init";
  final description = "Initiates configuration files.";

  InitCommand(String configPath) : super(configPath);

  Future run() async {
    var tasks = [_setUpConfigDir, _setUpScopesFile, _checkSecret]
        .map((f) => f(configPath));

    await Future.wait(tasks);
  }

  Future _setUpConfigDir(String configPath) async {
    print("Checking config directory setup...");
    var configDir = new Directory(configPath);
    var exists = await configDir.exists();
    if (!exists) await configDir.create(recursive: true);
  }

  Future _setUpScopesFile(String configPath) async {
    print("Setting up scopes file...");
    var availableScopeFile =
        new File(path.join(configPath, 'availablescopes.yaml'));
    var installedScopeFile = new File(path.join(configPath, 'scopes.yaml'));
    var sb = new StringBuffer();

    sb.writeln("base: email,profile");
    await installedScopeFile.writeAsString(sb.toString());

    await availableScopeFile.writeAsString(sb.toString());
  }

  Future _checkSecret(String configPath) async {
    print("Checking secret setup...");
    var secretFile = new File(path.join(configPath, 'secret.json'));
    var exists = await secretFile.exists();
    if (!exists) {
      print(
          "WARNING: Download credentials from google cloud as $configPath/secret.json.");
    }
  }
}
