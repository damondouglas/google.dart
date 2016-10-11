library google.crypt;

import 'package:gnupg/gnupg.dart' as gnupg;
import 'dart:async';

Future<String> encrypt(String data) {
  var command = new gnupg.EncryptCommand();
  return command.encrypt(data);
}

Future<String> decrypt(String data) {
  var command = new gnupg.DecryptCommand();
  return command.decrypt(data);
}
