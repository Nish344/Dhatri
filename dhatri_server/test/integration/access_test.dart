import 'package:dhatri_server/src/services/access_denied.dart';
import 'package:dhatri_server/src/services/access_logic.dart';
import 'package:serverpod_test/serverpod_test.dart';
import 'package:test/test.dart';

import 'package:dhatri_server/src/generated/protocol.dart';

import 'fixtures.dart';
import 'test_tools/serverpod_test_tools.dart';

void main() {
  group('verifyAccess', () {
    test('doctor cannot write', () {
      final doctor = Profile(name: 'Dr', role: Role.doctor, id: 1);
      final patient = Profile(
        name: 'P',
        role: Role.patient,
        id: 2,
        doctorId: 1,
      );
      expect(
        () => verifyAccess(doctor, patient, write: true),
        throwsA(isA<AccessDeniedException>()),
      );
    });

    test('unlinked caregiver denied', () {
      final cg = Profile(name: 'Ananya', role: Role.caregiver, id: 10);
      final patient = Profile(name: 'Ramesh', role: Role.patient, id: 20);
      expect(
        () => verifyAccess(cg, patient, write: true),
        throwsA(isA<AccessDeniedException>()),
      );
    });
  });

  withServerpod('Endpoint access', (sessionBuilder, endpoints) {
    test('unlinked caregiver cannot mark dose taken', () async {
      final setup = sessionBuilder.build();
      final patient = await insertProfile(
        setup,
        authUserId: 'pat-a',
        name: 'Ramesh',
        role: Role.patient,
      );
      final dose = await insertRemindedDose(setup, patientId: patient.id!);
      await insertProfile(
        setup,
        authUserId: 'cg-other',
        name: 'Stranger',
        role: Role.caregiver,
      );

      final cgBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'cg-other',
          {},
        ),
      );

      await expectLater(
        endpoints.dose.markTaken(cgBuilder, dose.id!),
        throwsA(isA<AccessDeniedException>()),
      );
    });

    test('doctor cannot acknowledge alert', () async {
      final setup = sessionBuilder.build();
      final doctor = await insertProfile(
        setup,
        authUserId: 'doc-b',
        name: 'Dr',
        role: Role.doctor,
      );
      final patient = await insertProfile(
        setup,
        authUserId: 'pat-b',
        name: 'Ramesh',
        role: Role.patient,
        doctorId: doctor.id,
      );

      final alert = await Alert.db.insertRow(
        setup,
        Alert(
          patientId: patient.id!,
          kind: AlertKind.missedDose,
          priority: AlertPriority.attention,
          message: 'test',
        ),
      );

      final docBuilder = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'doc-b',
          {},
        ),
      );

      await expectLater(
        endpoints.alert.acknowledge(docBuilder, alert.id!),
        throwsA(isA<AccessDeniedException>()),
      );
    });
  });
}
