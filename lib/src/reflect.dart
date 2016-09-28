library google.reflect;

import 'dart:async';
import 'dart:mirrors';
import 'package:args/command_runner.dart';

class ApiLibrary {
  Uri uri;
  ApiLibrary(this.uri);

  Command load() {
    var lib = currentMirrorSystem().libraries[uri];
    var api = lib.declarations.values.
    firstWhere(
      (mirror) => mirror.qualifiedName.toString().contains("Api") && !mirror.qualifiedName.toString().contains("Resource")
    );
    var command = new ApiCommand(api.simpleName);
    Map declarations = api.declarations;
    var apiPropertyKeys = declarations.keys.where((key) => declarations[key] is MethodMirror && !key.toString().contains("Api"));
    var apiPropertyMembers = apiPropertyKeys.map((key) => declarations[key]).toList();
    apiPropertyKeys
    .forEach((key) {
      var apiSubcommand = new ApiCommand(key);
      var property = declarations[key].returnType;
      var propertyMethods = property.declarations.keys.where((key) => property.declarations[key] is MethodMirror && !key.toString().contains("Api"));
      propertyMethods.forEach((methodKey) => apiSubcommand.addSubcommand(new ApiCommand(methodKey)));
      command.addSubcommand(apiSubcommand);
    });
    return command;
  }
}

class ApiCommand extends Command {
  String get name => _name;
  String _name;
  final description = "";
  ApiCommand(Symbol simpleName) {
    _name = simpleName.toString().toLowerCase();
    ["symbol", '\"',"(",")", "api"].forEach((token) => _name = _name.replaceAll(token, ""));
  }
}
