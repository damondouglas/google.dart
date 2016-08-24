import 'package:path/path.dart' as path;
import 'package:args/command_runner.dart';

abstract class BaseCommand extends Command {
  String configPath;
  String get secretPath => path.join(configPath, 'secret.json');
  String get scopesPath => path.join(configPath, 'scopes.yaml');
  String get credentialsPath => path.join(configPath, '.credentials');
  BaseCommand(this.configPath);
}
