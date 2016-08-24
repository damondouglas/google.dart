// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:google/google.dart' as google;
import 'package:args/command_runner.dart';
import 'dart:io';

main(List<String> arguments) {
  var homePath = Platform.environment['HOME'];
  var runner = new CommandRunner("google","");
  runner.argParser.addOption("config", abbr: 'c', help: 'Directory of configuration assets.', defaultsTo: '$homePath/.google');
  var results = runner.parse(arguments);
  runner
  ..addCommand(new google.AuthCommand(results['config']))
  ..run(arguments);
}
