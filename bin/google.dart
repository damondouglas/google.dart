// Copyright (c) 2016, see AUTHORS file. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:google/google.dart' as google;
import 'package:args/command_runner.dart';
import 'dart:io';

main(List<String> arguments) {
  var homePath = Platform.environment['HOME'];
  var runner = new CommandRunner("google", "");
  runner.argParser.addOption("config",
      abbr: 'c',
      help: 'Directory of configuration assets.',
      defaultsTo: '$homePath/.google');
  var results = runner.parse(arguments);

  var configPath = results['config'];

  var config = new google.Config(configPath);

  var commands = [
    new google.AuthCommand(configPath),
    new google.WhoamiCommand(configPath),
    new google.ScopeCommand(configPath),
    new google.InitCommand(configPath),
    new google.InstallCommand(configPath),
    new google.UtilCommand(configPath),
  ];

  var apiCommands = config.libraries.keys.map((String libraryName) {
    var lib = new google.ApiLibrary(config[libraryName], configPath);
    return lib.load();
  });

  commands.addAll(apiCommands);

  commands.forEach((Command command) => runner.addCommand(command));
  runner.run(arguments).catchError((Exception e, StackTrace stackTrace) {
    if (e is UsageException)
      print(e.usage);
    else {
      print(e);
      print(stackTrace);
    }
  });
}
