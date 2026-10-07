import 'package:serverpod/serverpod.dart';

import '../services/demo_seed.dart';

class DemoEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  Future<void> seed(Session session, String token) async {
    await assertDemoSeedAllowed(session, token);
    await seedDemoData(session);
  }

  Future<void> reset(Session session, String token) async {
    await assertDemoSeedAllowed(session, token);
    await resetDemoData(session);
  }
}
