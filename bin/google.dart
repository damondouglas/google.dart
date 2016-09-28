// Copyright (c) 2016, see AUTHORS file. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:google/google.dart' as google;
import 'package:args/command_runner.dart';
import 'dart:io';

main(List<String> arguments) {
  var calendar = new google.ApiLibrary(Uri.parse('package:googleapis/calendar/v3.dart'));
  var gmail = new google.ApiLibrary(Uri.parse('package:googleapis/gmail/v1.dart'));
  var drive = new google.ApiLibrary(Uri.parse('package:googleapis/drive/v3.dart'));
  var homePath = Platform.environment['HOME'];
  var runner = new CommandRunner("google","");
  runner.argParser.addOption("config", abbr: 'c', help: 'Directory of configuration assets.', defaultsTo: '$homePath/.google');
  var results = runner.parse(arguments);

  runner
  ..addCommand(new google.AuthCommand(results['config']))
  ..addCommand(new google.WhoamiCommand(results['config']))
  ..addCommand(new google.ScopeCommand(results['config']))
  ..addCommand(new google.InitCommand(results['config']))
  ..addCommand(calendar.load())
  ..addCommand(gmail.load())
  ..addCommand(drive.load())
  ..run(arguments)
  .catchError((UsageException e) {
    print(e.usage);
  });

}
