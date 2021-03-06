import 'package:path/path.dart' as path;
import 'package:args/command_runner.dart';

abstract class BaseCommand extends Command {
  String configPath;
  String get secretPath => path.join(configPath, 'secret.gpg');
  String get scopesPath => path.join(configPath, 'scopes.yaml');
  String get availableScopesPath =>
      path.join(configPath, 'availablescopes.yaml');
  String get credentialsPath => path.join(configPath, '.credentials.gpg');
  String get libPath => path.join(configPath, 'lib');
  BaseCommand(this.configPath);
}
