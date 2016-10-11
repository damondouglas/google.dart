import 'package:args/args.dart' as args;
import 'package:args/command_runner.dart';
import 'dart:async';
import 'base.dart';
import 'crypt.dart' as crypt;
import 'dart:io';
import 'package:path/path.dart' as path;

// Usage:
// var runner = new CommandRunner("...", "")
// ..addCommand(new EncryptCommand())
// ..run(args);

class EncryptCommand extends BaseCommand {
  final name = "encrypt";
  final description = "";

  EncryptCommand(String configPath) : super(configPath);

  Future run() async {
    var rest = argResults.rest;
    if (rest.isEmpty) {
      printUsage();
      exit(1);
    }

    var filePath = rest.first;

    var dataFile = new File(filePath);
    var exists = await dataFile.exists();
    if (!exists) {
      print("$filePath does not exist.");
      exit(1);
    }

    var data = await dataFile.readAsString();
    var encryptedData = await crypt.encrypt(data);
    print(encryptedData);
  }

  @override
  printUsage() {
    print("Usage:");
    print("google $name <path>");
    super.printUsage();
  }
}
