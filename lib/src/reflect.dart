library google.reflect;

import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:mirrors';
import 'package:args/command_runner.dart';
import 'base.dart';
import 'secret.dart' as secret;

// TODO: There must be a more elegant way to do this.
import 'package:googleapis/acceleratedmobilepageurl/v1.dart' deferred as a1;
import 'package:googleapis/adexchangebuyer/v1_3.dart' deferred as b1;
import 'package:googleapis/adexchangebuyer/v1_4.dart' deferred as c1;
import 'package:googleapis/adexchangeseller/v1_1.dart' deferred as d1;
import 'package:googleapis/adexchangeseller/v2_0.dart' deferred as e1;
import 'package:googleapis/admin/datatransfer_v1.dart' deferred as f1;
import 'package:googleapis/admin/directory_v1.dart' deferred as g1;
import 'package:googleapis/admin/reports_v1.dart' deferred as h1;
import 'package:googleapis/adsense/v1_4.dart' deferred as i1;
import 'package:googleapis/adsensehost/v4_1.dart' deferred as j1;
import 'package:googleapis/analytics/v3.dart' deferred as k1;
import 'package:googleapis/analyticsreporting/v4.dart' deferred as l1;
import 'package:googleapis/androidenterprise/v1.dart' deferred as m1;
import 'package:googleapis/androidpublisher/v2.dart' deferred as n1;
import 'package:googleapis/appengine/v1.dart' deferred as o1;
import 'package:googleapis/appsactivity/v1.dart' deferred as p1;
import 'package:googleapis/appstate/v1.dart' deferred as q1;
import 'package:googleapis/bigquery/v2.dart' deferred as r1;
import 'package:googleapis/blogger/v3.dart' deferred as s1;
import 'package:googleapis/books/v1.dart' deferred as t1;
import 'package:googleapis/calendar/v3.dart' deferred as u1;
import 'package:googleapis/civicinfo/v2.dart' deferred as v1;
import 'package:googleapis/classroom/v1.dart' deferred as w1;
import 'package:googleapis/cloudbilling/v1.dart' deferred as x1;
import 'package:googleapis/clouddebugger/v2.dart' deferred as y1;
import 'package:googleapis/cloudresourcemanager/v1.dart' deferred as z1;
import 'package:googleapis/cloudtrace/v1.dart' deferred as a2;
import 'package:googleapis/compute/v1.dart' deferred as b2;
import 'package:googleapis/consumersurveys/v2.dart' deferred as c2;
import 'package:googleapis/container/v1.dart' deferred as d2;
import 'package:googleapis/content/v2.dart' deferred as e2;
import 'package:googleapis/content/v2sandbox.dart' deferred as f2;
import 'package:googleapis/customsearch/v1.dart' deferred as g2;
import 'package:googleapis/dataproc/v1.dart' deferred as h2;
import 'package:googleapis/deploymentmanager/v2.dart' deferred as i2;
import 'package:googleapis/dfareporting/v2_2.dart' deferred as j2;
import 'package:googleapis/dfareporting/v2_3.dart' deferred as k2;
import 'package:googleapis/dfareporting/v2_4.dart' deferred as l2;
import 'package:googleapis/dfareporting/v2_5.dart' deferred as m2;
import 'package:googleapis/discovery/v1.dart' deferred as n2;
import 'package:googleapis/dns/v1.dart' deferred as o2;
import 'package:googleapis/doubleclickbidmanager/v1.dart' deferred as p2;
import 'package:googleapis/doubleclicksearch/v2.dart' deferred as q2;
import 'package:googleapis/drive/v2.dart' deferred as r2;
import 'package:googleapis/drive/v3.dart' deferred as s2;
import 'package:googleapis/firebaserules/v1.dart' deferred as t2;
import 'package:googleapis/fitness/v1.dart' deferred as u2;
import 'package:googleapis/freebase/v1.dart' deferred as v2;
import 'package:googleapis/fusiontables/v1.dart' deferred as w2;
import 'package:googleapis/fusiontables/v2.dart' deferred as x2;
import 'package:googleapis/games/v1.dart' deferred as y2;
import 'package:googleapis/gamesconfiguration/v1configuration.dart' deferred as z2;
import 'package:googleapis/gamesmanagement/v1management.dart' deferred as a3;
import 'package:googleapis/genomics/v1.dart' deferred as b3;
import 'package:googleapis/gmail/v1.dart' deferred as c3;
import 'package:googleapis/groupsmigration/v1.dart' deferred as d3;
import 'package:googleapis/groupssettings/v1.dart' deferred as e3;
import 'package:googleapis/iam/v1.dart' deferred as f3;
import 'package:googleapis/identitytoolkit/v3.dart' deferred as g3;
import 'package:googleapis/kgsearch/v1.dart' deferred as h3;
import 'package:googleapis/licensing/v1.dart' deferred as i3;
import 'package:googleapis/mirror/v1.dart' deferred as j3;
import 'package:googleapis/monitoring/v3.dart' deferred as k3;
import 'package:googleapis/oauth2/v2.dart' deferred as l3;
import 'package:googleapis/pagespeedonline/v1.dart' deferred as m3;
import 'package:googleapis/pagespeedonline/v2.dart' deferred as n3;
import 'package:googleapis/partners/v2.dart' deferred as o3;
import 'package:googleapis/people/v1.dart' deferred as p3;
import 'package:googleapis/playmoviespartner/v1.dart' deferred as q3;
import 'package:googleapis/plus/v1.dart' deferred as r3;
import 'package:googleapis/plusdomains/v1.dart' deferred as s3;
import 'package:googleapis/prediction/v1_6.dart' deferred as t3;
import 'package:googleapis/pubsub/v1.dart' deferred as u3;
import 'package:googleapis/qpxexpress/v1.dart' deferred as v3;
import 'package:googleapis/reseller/v1.dart' deferred as w3;
import 'package:googleapis/safebrowsing/v4.dart' deferred as x3;
import 'package:googleapis/script/v1.dart' deferred as y3;
import 'package:googleapis/sheets/v4.dart' deferred as z3;
import 'package:googleapis/siteverification/v1.dart' deferred as a4;
import 'package:googleapis/storage/v1.dart' deferred as b4;
import 'package:googleapis/storagetransfer/v1.dart' deferred as c4;
import 'package:googleapis/tagmanager/v1.dart' deferred as d4;
import 'package:googleapis/tasks/v1.dart' deferred as e4;
import 'package:googleapis/translate/v2.dart' deferred as f4;
import 'package:googleapis/urlshortener/v1.dart' deferred as g4;
import 'package:googleapis/vision/v1.dart' deferred as h4;
import 'package:googleapis/webfonts/v1.dart' deferred as i4;
import 'package:googleapis/webmasters/v3.dart' deferred as j4;
import 'package:googleapis/youtube/v3.dart' deferred as k4;
import 'package:googleapis/youtubeanalytics/v1.dart' deferred as l4;
import 'package:googleapis/youtubereporting/v1.dart' deferred as m4;

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
    apiPropertyKeys.forEach((propertyName) {
      var apiSubcommand = new ResourceApiCommand(propertyName, configPath); //specialize
      var property = declarations[propertyName].returnType;
      var propertyMethods = property.declarations.keys.where((key) =>
          property.declarations[key] is MethodMirror &&
          !key.toString().contains("Api"));

      propertyMethods.forEach((methodKey) {
        MethodMirror methodMirror = property.declarations[methodKey];
        apiSubcommand.addSubcommand(new MethodCommand(api, propertyName, methodMirror, methodKey, configPath)); //specialize
      });
      command.addSubcommand(apiSubcommand);
    });
    return command;
  }
}

class MethodCommand extends BaseApiCommand {
  List<String> positionalParameters = [];
  ClassMirror apiMirror;
  String apiName;
  String propertyName;
  MethodMirror methodMirror;
  ClassMirror get classMirror => reflect(simpleName) as ClassMirror;
  Future<InstanceMirror> get instanceMirror => new Future(() async {
    var client = await secret.loadClient(secretPath, credentialsPath);
    return classMirror.newInstance(const Symbol(''), [client]);
  });
  MethodCommand(this.apiMirror, this.propertyName, this.methodMirror, Symbol simpleName, String configPath) : super(simpleName, configPath) {
    apiName = MirrorSystem.getName(this.apiMirror.simpleName);
    List<ParameterMirror> parameterMirrors = methodMirror.parameters;
    parameterMirrors.forEach((ParameterMirror parameter) {
      var parameterName = MirrorSystem.getName(parameter.simpleName);
      if (parameter.isNamed) {
        argParser.addOption(parameterName, help: 'Required: ${!parameter.isOptional}');
      } else {
        positionalParameters.add(parameterName);
      }
    });
  }

  Future run() async {
    var client = await secret.loadClient(secretPath, credentialsPath);
    var arguments = argResults.arguments;
    var rest = argResults.rest;
    var api = apiMirror.newInstance(new Symbol(''), [client]);
    var property = api.getField(propertyName);
    var methodName = methodMirror.simpleName;
    if (rest.length != positionalParameters.length) {
      printUsage();
      print('');
      print("arguments: $positionalParameters");
    }

    var resultMirror = property.invoke(methodName, rest);
    var result = await resultMirror.reflectee;
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String prettyPrintResult = encoder.convert(result);
    print(prettyPrintResult);
    exit(0);
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
