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
import 'dart:async' as _ida;
import 'dart:typed_data' as _idt;
import 'package:dhatri_client/src/protocol/alert.dart' as _inc575eh;
import 'package:dhatri_client/src/protocol/care_update.dart' as _iayxhvpt;
import 'package:dhatri_client/src/protocol/check_in_turn.dart' as _ie8i12iu;
import 'package:dhatri_client/src/protocol/dose_event.dart' as _iav2z4fb;
import 'package:dhatri_client/src/protocol/medication.dart' as _iyn1i8v5;
import 'package:dhatri_client/src/protocol/medication_draft.dart' as _it8rgm70;
import 'package:dhatri_client/src/protocol/patient_insight.dart' as _ixe9aai8;
import 'package:dhatri_client/src/protocol/patient_status.dart' as _isnu78ia;
import 'package:dhatri_client/src/protocol/prescription.dart' as _i10iuu6d;
import 'package:dhatri_client/src/protocol/profile.dart' as _ii1trskb;
import 'package:dhatri_client/src/protocol/role.dart' as _i14s3qox;
import 'package:dhatri_client/src/protocol/timeline_item.dart' as _ivovkn5g;
import 'package:dhatri_client/src/protocol/upload_ticket.dart' as _ic8ggen5;
import 'package:dhatri_client/src/protocol/wellness_check.dart' as _ixcmz0zn;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// {@category Endpoint}
class EndpointAlert extends _isc.EndpointRef {
  EndpointAlert(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'alert';

  _ida.Future<_inc575eh.Alert> acknowledge(int alertId) =>
      caller.callServerEndpoint<_inc575eh.Alert>(
        'alert',
        'acknowledge',
        {'alertId': alertId},
      );

  _ida.Future<_inc575eh.Alert> needHelp(int patientId) =>
      caller.callServerEndpoint<_inc575eh.Alert>(
        'alert',
        'needHelp',
        {'patientId': patientId},
      );
}

/// {@category Endpoint}
class EndpointCareStream extends _isc.EndpointRef {
  EndpointCareStream(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'careStream';

  _ida.Stream<_iayxhvpt.CareUpdate> watch(int patientId) =>
      caller.callStreamingServerEndpoint<
        _ida.Stream<_iayxhvpt.CareUpdate>,
        _iayxhvpt.CareUpdate
      >(
        'careStream',
        'watch',
        {'patientId': patientId},
        {},
      );
}

/// {@category Endpoint}
class EndpointCheckIn extends _isc.EndpointRef {
  EndpointCheckIn(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checkIn';

  _ida.Future<void> startNow(int patientId) => caller.callServerEndpoint<void>(
    'checkIn',
    'startNow',
    {'patientId': patientId},
  );

  _ida.Future<_ixcmz0zn.WellnessCheck?> pending(int patientId) =>
      caller.callServerEndpoint<_ixcmz0zn.WellnessCheck?>(
        'checkIn',
        'pending',
        {'patientId': patientId},
      );

  _ida.Future<_ie8i12iu.CheckInTurn> accept(int checkId) =>
      caller.callServerEndpoint<_ie8i12iu.CheckInTurn>(
        'checkIn',
        'accept',
        {'checkId': checkId},
      );

  _ida.Future<void> snooze(int checkId) => caller.callServerEndpoint<void>(
    'checkIn',
    'snooze',
    {'checkId': checkId},
  );

  _ida.Future<_ie8i12iu.CheckInTurn> answer(
    int checkId,
    _idt.ByteData audio,
  ) => caller.callServerEndpoint<_ie8i12iu.CheckInTurn>(
    'checkIn',
    'answer',
    {
      'checkId': checkId,
      'audio': audio,
    },
  );

  /// Hindi tap-to-answer fallback when speech recognition is unreliable.
  _ida.Future<_ie8i12iu.CheckInTurn> answerText(
    int checkId,
    String transcript,
  ) => caller.callServerEndpoint<_ie8i12iu.CheckInTurn>(
    'checkIn',
    'answerText',
    {
      'checkId': checkId,
      'transcript': transcript,
    },
  );
}

/// {@category Endpoint}
class EndpointDemo extends _isc.EndpointRef {
  EndpointDemo(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'demo';

  _ida.Future<void> seed(String token) => caller.callServerEndpoint<void>(
    'demo',
    'seed',
    {'token': token},
  );

  _ida.Future<void> reset(String token) => caller.callServerEndpoint<void>(
    'demo',
    'reset',
    {'token': token},
  );
}

/// {@category Endpoint}
class EndpointDose extends _isc.EndpointRef {
  EndpointDose(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'dose';

  _ida.Future<List<_iav2z4fb.DoseEvent>> today(int patientId) =>
      caller.callServerEndpoint<List<_iav2z4fb.DoseEvent>>(
        'dose',
        'today',
        {'patientId': patientId},
      );

  _ida.Future<_iav2z4fb.DoseEvent> markTaken(int doseEventId) =>
      caller.callServerEndpoint<_iav2z4fb.DoseEvent>(
        'dose',
        'markTaken',
        {'doseEventId': doseEventId},
      );
}

/// {@category Endpoint}
class EndpointInsight extends _isc.EndpointRef {
  EndpointInsight(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'insight';

  _ida.Future<_ixe9aai8.PatientInsight> week(int patientId) =>
      caller.callServerEndpoint<_ixe9aai8.PatientInsight>(
        'insight',
        'week',
        {'patientId': patientId},
      );

  _ida.Future<List<_ivovkn5g.TimelineItem>> timeline(
    int patientId,
    int days,
  ) => caller.callServerEndpoint<List<_ivovkn5g.TimelineItem>>(
    'insight',
    'timeline',
    {
      'patientId': patientId,
      'days': days,
    },
  );
}

/// {@category Endpoint}
class EndpointPatients extends _isc.EndpointRef {
  EndpointPatients(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'patients';

  _ida.Future<List<_isnu78ia.PatientStatus>> overview() =>
      caller.callServerEndpoint<List<_isnu78ia.PatientStatus>>(
        'patients',
        'overview',
        {},
      );
}

/// {@category Endpoint}
class EndpointPrescription extends _isc.EndpointRef {
  EndpointPrescription(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'prescription';

  _ida.Future<_ic8ggen5.UploadTicket> uploadTicket(int patientId) =>
      caller.callServerEndpoint<_ic8ggen5.UploadTicket>(
        'prescription',
        'uploadTicket',
        {'patientId': patientId},
      );

  _ida.Future<_i10iuu6d.Prescription> submit(
    int patientId,
    String path,
  ) => caller.callServerEndpoint<_i10iuu6d.Prescription>(
    'prescription',
    'submit',
    {
      'patientId': patientId,
      'path': path,
    },
  );

  _ida.Future<List<_it8rgm70.MedicationDraft>> drafts(int prescriptionId) =>
      caller.callServerEndpoint<List<_it8rgm70.MedicationDraft>>(
        'prescription',
        'drafts',
        {'prescriptionId': prescriptionId},
      );

  _ida.Future<List<_iyn1i8v5.Medication>> confirm(
    int prescriptionId,
    List<_it8rgm70.MedicationDraft> meds,
  ) => caller.callServerEndpoint<List<_iyn1i8v5.Medication>>(
    'prescription',
    'confirm',
    {
      'prescriptionId': prescriptionId,
      'meds': meds,
    },
  );
}

/// {@category Endpoint}
class EndpointProfile extends _isc.EndpointRef {
  EndpointProfile(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'profile';

  _ida.Future<_ii1trskb.Profile?> me() =>
      caller.callServerEndpoint<_ii1trskb.Profile?>(
        'profile',
        'me',
        {},
      );

  _ida.Future<_ii1trskb.Profile> register(
    String name,
    _i14s3qox.Role role,
    int? age,
    String? phone,
  ) => caller.callServerEndpoint<_ii1trskb.Profile>(
    'profile',
    'register',
    {
      'name': name,
      'role': role,
      'age': age,
      'phone': phone,
    },
  );

  _ida.Future<_ii1trskb.Profile> link(String code) =>
      caller.callServerEndpoint<_ii1trskb.Profile>(
        'profile',
        'link',
        {'code': code},
      );

  _ida.Future<List<_ii1trskb.Profile>> myPatients() =>
      caller.callServerEndpoint<List<_ii1trskb.Profile>>(
        'profile',
        'myPatients',
        {},
      );

  _ida.Future<_ii1trskb.Profile?> caregiverContact(int patientId) =>
      caller.callServerEndpoint<_ii1trskb.Profile?>(
        'profile',
        'caregiverContact',
        {'patientId': patientId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    alert = EndpointAlert(this);
    careStream = EndpointCareStream(this);
    checkIn = EndpointCheckIn(this);
    demo = EndpointDemo(this);
    dose = EndpointDose(this);
    insight = EndpointInsight(this);
    patients = EndpointPatients(this);
    prescription = EndpointPrescription(this);
    profile = EndpointProfile(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAlert alert;

  late final EndpointCareStream careStream;

  late final EndpointCheckIn checkIn;

  late final EndpointDemo demo;

  late final EndpointDose dose;

  late final EndpointInsight insight;

  late final EndpointPatients patients;

  late final EndpointPrescription prescription;

  late final EndpointProfile profile;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'alert': alert,
    'careStream': careStream,
    'checkIn': checkIn,
    'demo': demo,
    'dose': dose,
    'insight': insight,
    'patients': patients,
    'prescription': prescription,
    'profile': profile,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
