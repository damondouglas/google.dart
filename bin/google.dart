// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:google/google.dart' as google;
import 'package:args/command_runner.dart';

main(List<String> arguments) {
  var runner = new CommandRunner("google","")
  ..addCommand(new google.AuthCommand())
  ..run(arguments);
}
