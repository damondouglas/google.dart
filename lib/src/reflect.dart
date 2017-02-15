library google.reflect;

import 'dart:async';
import 'dart:mirrors';
import 'package:args/command_runner.dart';
import 'base.dart';
import 'secret.dart' as secret;

class ApiLibrary {
  Uri uri;
  String configPath;
  ApiLibrary(this.uri, this.configPath);

  Command load() {
    var lib = currentMirrorSystem().libraries[uri];
    var api = lib.declarations.values.firstWhere((mirror) =>
        mirror.qualifiedName.toString().contains("Api") &&
        !mirror.qualifiedName.toString().contains("Resource"));
    var command = new ApiCommand(api.simpleName, configPath); //specialize
    Map declarations = api.declarations;
    var apiPropertyKeys = declarations.keys.where((key) =>
        declarations[key] is MethodMirror && !key.toString().contains("Api"));
    var apiPropertyMembers =
        apiPropertyKeys.map((key) => declarations[key]).toList();
    apiPropertyKeys.forEach((key) {
      var apiSubcommand = new ResourceApiCommand(key, configPath); //specialize
      var property = declarations[key].returnType;
      var propertyMethods = property.declarations.keys.where((key) =>
          property.declarations[key] is MethodMirror &&
          !key.toString().contains("Api"));
      propertyMethods.forEach((methodKey) =>
          apiSubcommand.addSubcommand(new ApiCommand(methodKey, configPath))); //specialize
      command.addSubcommand(apiSubcommand);
    });
    return command;
  }
}

class ApiCommand extends BaseApiCommand {
  ClassMirror get classMirror => reflect(simpleName) as ClassMirror;
  Future<InstanceMirror> get instanceMirror => new Future(() async {
    var client = await secret.loadClient(secretPath, credentialsPath);
    return classMirror.newInstance(const Symbol(''), [client]);
  });
  ApiCommand(Symbol simpleName, String configPath) : super(simpleName, configPath);
}

class ResourceApiCommand extends BaseApiCommand {
  Future<InstanceMirror> get parentInstanceMirror => (this.parent as ApiCommand).instanceMirror;
  ResourceApiCommand(Symbol simpleName, String configPath) : super(simpleName, configPath);
  Future<InstanceMirror> get instanceMirror => new Future(() async {
    var parentInstance = await parentInstanceMirror;
    return parentInstance.getField(simpleName);
  });
}

class BaseApiCommand extends BaseCommand {
  String get name => MirrorSystem.getName(simpleName).toLowerCase().replaceAll("api", "");
  Symbol simpleName;
  final description = "";
  BaseApiCommand(this.simpleName, String configPath) : super(configPath);
}

class LibraryReflector {
  Uri uri;
  LibraryReflector(this.uri);
  List<Uri> get available => (){
    print(this.uri.toFilePath());
    return [];
  }();
}
