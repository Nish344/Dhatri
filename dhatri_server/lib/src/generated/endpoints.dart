/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:dhatri_server/src/generated/future_calls.dart' as _isjznajl;
import 'package:dhatri_server/src/generated/medication_draft.dart' as _i5ggnd2q;
import 'package:dhatri_server/src/generated/role.dart' as _is2cumq0;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/alert_endpoint.dart' as _i7qz57d6;
import '../endpoints/care_stream_endpoint.dart' as _iyvwz1e0;
import '../endpoints/check_in_endpoint.dart' as _i87fx0af;
import '../endpoints/demo_endpoint.dart' as _irow5ity;
import '../endpoints/dose_endpoint.dart' as _izftciif;
import '../endpoints/insight_endpoint.dart' as _iwdo2kkc;
import '../endpoints/patients_endpoint.dart' as _ils7jkvy;
import '../endpoints/prescription_endpoint.dart' as _ir96hk1b;
import '../endpoints/profile_endpoint.dart' as _i2cx2pww;
export 'future_calls.dart' show ServerpodFutureCallsGetter;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'alert': _i7qz57d6.AlertEndpoint()
        ..initialize(
          server,
          'alert',
          null,
        ),
      'careStream': _iyvwz1e0.CareStreamEndpoint()
        ..initialize(
          server,
          'careStream',
          null,
        ),
      'checkIn': _i87fx0af.CheckInEndpoint()
        ..initialize(
          server,
          'checkIn',
          null,
        ),
      'demo': _irow5ity.DemoEndpoint()
        ..initialize(
          server,
          'demo',
          null,
        ),
      'dose': _izftciif.DoseEndpoint()
        ..initialize(
          server,
          'dose',
          null,
        ),
      'insight': _iwdo2kkc.InsightEndpoint()
        ..initialize(
          server,
          'insight',
          null,
        ),
      'patients': _ils7jkvy.PatientsEndpoint()
        ..initialize(
          server,
          'patients',
          null,
        ),
      'prescription': _ir96hk1b.PrescriptionEndpoint()
        ..initialize(
          server,
          'prescription',
          null,
        ),
      'profile': _i2cx2pww.ProfileEndpoint()
        ..initialize(
          server,
          'profile',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['alert'] = _is.EndpointConnector(
      name: 'alert',
      endpoint: endpoints['alert']!,
      methodConnectors: {
        'acknowledge': _is.MethodConnector(
          name: 'acknowledge',
          params: {
            'alertId': _is.ParameterDescription(
              name: 'alertId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).acknowledge(
                    session,
                    params['alertId'],
                  ),
        ),
        'needHelp': _is.MethodConnector(
          name: 'needHelp',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['alert'] as _i7qz57d6.AlertEndpoint).needHelp(
                    session,
                    params['patientId'],
                  ),
        ),
      },
    );
    connectors['careStream'] = _is.EndpointConnector(
      name: 'careStream',
      endpoint: endpoints['careStream']!,
      methodConnectors: {
        'watch': _is.MethodStreamConnector(
          name: 'watch',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          streamParams: {},
          returnType: _is.MethodStreamReturnType.streamType,
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['careStream'] as _iyvwz1e0.CareStreamEndpoint)
                  .watch(
                    session,
                    params['patientId'],
                  ),
        ),
      },
    );
    connectors['checkIn'] = _is.EndpointConnector(
      name: 'checkIn',
      endpoint: endpoints['checkIn']!,
      methodConnectors: {
        'startNow': _is.MethodConnector(
          name: 'startNow',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint).startNow(
                    session,
                    params['patientId'],
                  ),
        ),
        'pending': _is.MethodConnector(
          name: 'pending',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint).pending(
                    session,
                    params['patientId'],
                  ),
        ),
        'accept': _is.MethodConnector(
          name: 'accept',
          params: {
            'checkId': _is.ParameterDescription(
              name: 'checkId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint).accept(
                    session,
                    params['checkId'],
                  ),
        ),
        'snooze': _is.MethodConnector(
          name: 'snooze',
          params: {
            'checkId': _is.ParameterDescription(
              name: 'checkId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint).snooze(
                    session,
                    params['checkId'],
                  ),
        ),
        'answer': _is.MethodConnector(
          name: 'answer',
          params: {
            'checkId': _is.ParameterDescription(
              name: 'checkId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'audio': _is.ParameterDescription(
              name: 'audio',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint).answer(
                    session,
                    params['checkId'],
                    params['audio'],
                  ),
        ),
        'answerText': _is.MethodConnector(
          name: 'answerText',
          params: {
            'checkId': _is.ParameterDescription(
              name: 'checkId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'transcript': _is.ParameterDescription(
              name: 'transcript',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['checkIn'] as _i87fx0af.CheckInEndpoint)
                  .answerText(
                    session,
                    params['checkId'],
                    params['transcript'],
                  ),
        ),
      },
    );
    connectors['demo'] = _is.EndpointConnector(
      name: 'demo',
      endpoint: endpoints['demo']!,
      methodConnectors: {
        'seed': _is.MethodConnector(
          name: 'seed',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['demo'] as _irow5ity.DemoEndpoint).seed(
                session,
                params['token'],
              ),
        ),
        'reset': _is.MethodConnector(
          name: 'reset',
          params: {
            'token': _is.ParameterDescription(
              name: 'token',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['demo'] as _irow5ity.DemoEndpoint).reset(
                session,
                params['token'],
              ),
        ),
      },
    );
    connectors['dose'] = _is.EndpointConnector(
      name: 'dose',
      endpoint: endpoints['dose']!,
      methodConnectors: {
        'today': _is.MethodConnector(
          name: 'today',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['dose'] as _izftciif.DoseEndpoint).today(
                session,
                params['patientId'],
              ),
        ),
        'markTaken': _is.MethodConnector(
          name: 'markTaken',
          params: {
            'doseEventId': _is.ParameterDescription(
              name: 'doseEventId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['dose'] as _izftciif.DoseEndpoint).markTaken(
                    session,
                    params['doseEventId'],
                  ),
        ),
      },
    );
    connectors['insight'] = _is.EndpointConnector(
      name: 'insight',
      endpoint: endpoints['insight']!,
      methodConnectors: {
        'week': _is.MethodConnector(
          name: 'week',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insight'] as _iwdo2kkc.InsightEndpoint).week(
                    session,
                    params['patientId'],
                  ),
        ),
        'timeline': _is.MethodConnector(
          name: 'timeline',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'days': _is.ParameterDescription(
              name: 'days',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['insight'] as _iwdo2kkc.InsightEndpoint).timeline(
                    session,
                    params['patientId'],
                    params['days'],
                  ),
        ),
      },
    );
    connectors['patients'] = _is.EndpointConnector(
      name: 'patients',
      endpoint: endpoints['patients']!,
      methodConnectors: {
        'overview': _is.MethodConnector(
          name: 'overview',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['patients'] as _ils7jkvy.PatientsEndpoint)
                  .overview(session),
        ),
      },
    );
    connectors['prescription'] = _is.EndpointConnector(
      name: 'prescription',
      endpoint: endpoints['prescription']!,
      methodConnectors: {
        'uploadTicket': _is.MethodConnector(
          name: 'uploadTicket',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['prescription'] as _ir96hk1b.PrescriptionEndpoint)
                      .uploadTicket(
                        session,
                        params['patientId'],
                      ),
        ),
        'submit': _is.MethodConnector(
          name: 'submit',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'path': _is.ParameterDescription(
              name: 'path',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['prescription'] as _ir96hk1b.PrescriptionEndpoint)
                      .submit(
                        session,
                        params['patientId'],
                        params['path'],
                      ),
        ),
        'drafts': _is.MethodConnector(
          name: 'drafts',
          params: {
            'prescriptionId': _is.ParameterDescription(
              name: 'prescriptionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['prescription'] as _ir96hk1b.PrescriptionEndpoint)
                      .drafts(
                        session,
                        params['prescriptionId'],
                      ),
        ),
        'confirm': _is.MethodConnector(
          name: 'confirm',
          params: {
            'prescriptionId': _is.ParameterDescription(
              name: 'prescriptionId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'meds': _is.ParameterDescription(
              name: 'meds',
              type: _is.getType<List<_i5ggnd2q.MedicationDraft>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['prescription'] as _ir96hk1b.PrescriptionEndpoint)
                      .confirm(
                        session,
                        params['prescriptionId'],
                        params['meds'],
                      ),
        ),
      },
    );
    connectors['profile'] = _is.EndpointConnector(
      name: 'profile',
      endpoint: endpoints['profile']!,
      methodConnectors: {
        'me': _is.MethodConnector(
          name: 'me',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).me(
                session,
              ),
        ),
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'role': _is.ParameterDescription(
              name: 'role',
              type: _is.getType<_is2cumq0.Role>(),
              nullable: false,
            ),
            'age': _is.ParameterDescription(
              name: 'age',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'phone': _is.ParameterDescription(
              name: 'phone',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).register(
                    session,
                    params['name'],
                    params['role'],
                    params['age'],
                    params['phone'],
                  ),
        ),
        'link': _is.MethodConnector(
          name: 'link',
          params: {
            'code': _is.ParameterDescription(
              name: 'code',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['profile'] as _i2cx2pww.ProfileEndpoint).link(
                    session,
                    params['code'],
                  ),
        ),
        'myPatients': _is.MethodConnector(
          name: 'myPatients',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i2cx2pww.ProfileEndpoint)
                  .myPatients(session),
        ),
        'caregiverContact': _is.MethodConnector(
          name: 'caregiverContact',
          params: {
            'patientId': _is.ParameterDescription(
              name: 'patientId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['profile'] as _i2cx2pww.ProfileEndpoint)
                  .caregiverContact(
                    session,
                    params['patientId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }

  @override
  _is.FutureCallDispatch? get futureCalls {
    return _isjznajl.FutureCalls();
  }
}
