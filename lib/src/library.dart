library google.library;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

final _CONFIG_FILE_NAME = 'libraries.json';
final _URI = 'uri';

Future<List<String>> getAvailableLibraries() async {
  var dirs = await getLibraryDirs();
  return dirs
  .map((Directory dir) => path.basename(dir.path))
  .toList();
}

Future<List<Directory>> getLibraryDirs() async {
  var packagesFile = new File('.packages');
  var packagesFileExists = await packagesFile.exists();
  assert(packagesFileExists, '$packagesFile does not exist');
  var lines = await packagesFile.readAsLines();
  var googleApis = lines.firstWhere((line) => line.contains('googleapis:'));
  assert(googleApis.isNotEmpty, 'googleApis is empty');
  var libDirUriSplit = googleApis.split(':');
  assert(libDirUriSplit.length == 2, 'libDirUri length should be 2');
  var lib = new Directory(libDirUriSplit.last);
  return await lib.list()
  .where((FileSystemEntity fse) => fse is Directory)
  .map((FileSystemEntity fse) => new Directory.fromUri(fse.uri))
  .toList();
}

Future<List<String>> getVersions(Directory libraryDir) async {
  var vList = await libraryDir.list()
  .map((FileSystemEntity fse) => fse as File)
  .map((File f) => path.basename(f.path))
  .toList();

  vList.sort();

  return vList;
}

Config _config;

class Config {
  Map libraries;
  File configFile;
  Config(String configPathDir) {
    configFile = new File(path.join(configPathDir, _CONFIG_FILE_NAME));
    var configData = configFile.readAsStringSync();
    libraries = JSON.decode(configData);
  }

  save(String name, String uri) {
    libraries[name] = {_URI: uri};
    configFile.writeAsStringSync(JSON.encode(libraries));
  }

  Uri operator [](String libraryName) => Uri.parse(libraries[libraryName][_URI]);
}
