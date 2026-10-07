import 'package:serverpod/serverpod.dart';

class DemoEndpoint extends Endpoint {
  Future<void> seed(Session session, String token) async =>
      throw UnimplementedError();

  Future<void> reset(Session session, String token) async =>
      throw UnimplementedError();
}
