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

  var calendar = new google.ApiLibrary(
      Uri.parse('package:googleapis/calendar/v3.dart'), results['config']);
  var gmail = new google.ApiLibrary(
      Uri.parse('package:googleapis/gmail/v1.dart'), results['config']);
  var drive = new google.ApiLibrary(
      Uri.parse('package:googleapis/drive/v3.dart'), results['config']);

  var configPath = results['config'];

  runner
    ..addCommand(new google.AuthCommand(configPath))
    ..addCommand(new google.WhoamiCommand(configPath))
    ..addCommand(new google.ScopeCommand(configPath))
    ..addCommand(new google.InitCommand(configPath))
    ..addCommand(new google.EncryptCommand(configPath))
    ..addCommand(new google.DecryptCommand(configPath))
    ..addCommand(calendar.load())
    ..addCommand(gmail.load())
    ..addCommand(drive.load())
    ..run(arguments).catchError((Exception e, StackTrace stackTrace) {
      if (e is UsageException)
        print(e.usage);
      else {
        print(e);
        print(stackTrace);
      }
    });
}
