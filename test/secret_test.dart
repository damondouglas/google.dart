import 'package:test/test.dart';
import 'dart:io';
import 'package:google/src/secret.dart' as secret;

var _secretPath = 'secret.json';
secret.Secret cred;

main() {
  setUp(() {
    cred = new secret.Secret.from(_secretPath);
  });
  test_constructor();
}

test_constructor() {
  test("should build secret from input file path", () {
    expect(cred.clientId.endsWith("apps.googleusercontent.com"), isTrue);
    expect(cred.clientSecret, isNotNull);
  });
}
