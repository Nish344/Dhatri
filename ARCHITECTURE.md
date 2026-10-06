# Dhatri — Architecture

Dhatri turns a photo of a prescription into a dose schedule, reminds the patient, alerts the caregiver live when a dose is missed, runs a Hindi voice care call that remembers what the patient said before, and gives the caregiver and the doctor a short, factual picture of what changed.

**Document order of authority:** product guides 
PLAN.md
→ What we must build, in what order, and what is out of scope.
ARCHITECTURE.md
→ Exactly how the implementation works.
Dhatri UI/UX Guide
→ How those exact planned features should look and behave.
Overall Project Summary
→ Product vision, rationale, and future capabilities.

---

## 1. Scope

Tiers come from the summary guide §16. A tier-1 item is never started until all tier-0 items work on two phones.

| Tier | Built | Not built (reason in DECISIONS.md) |
|---|---|---|
| **P0 core loop** | Patient, caregiver and doctor sign-in with roles. Prescription photo → AI draft → human confirm. Dose events, reminder, Taken. Missed-dose escalation. Live caregiver alert. Basic health timeline. Tap-to-call (`tel:`) | |
| **P1 differentiators** | In-app Hindi care call (Sarvam STT/TTS), up to 2 turns. Symptom extraction and repeat rule. Patient Memory (pgvector retrieval, SQL fallback). Weekly insight with AI summary. Read-only doctor dashboard. Caregiver triage list | |
| **P2 only after the P1 gate and before freeze** | Local dose notifications on the patient phone. Caregiver playback of the patient's recorded answer | Exotel phone calls, Piper, IndicF5, FCM push, durable offline sync, doctor write actions, payments, chat |

One thin interface is kept so the voice vendor is swappable, as the guide asks: `VoiceEngine { transcribe, speak }`, implemented only by `SarvamVoice`.

---

## 2. Repository layout

```text
dhatri/
  AGENTS.md  PLAN.md  ARCHITECTURE.md
  docs/  (guides, DECISIONS.md, SCREENS.md, DEMO.md)
  dhatri_server/
    lib/src/models/          *.spy.yaml
    lib/src/endpoints/       one file per endpoint
    lib/src/future_calls/    prescription, dose, check-in
    lib/src/services/        access.dart  dose_rules.dart  symptom_rules.dart
                             safety_rules.dart  voice_engine.dart  sarvam.dart
                             gemini.dart  memory_service.dart  insight_service.dart
                             copy_hi.dart  care_bus.dart
    config/                  development.yaml  production.yaml  passwords.yaml (gitignored)
    migrations/
    test/integration/
  dhatri_client/             generated, committed, never hand-edited
  dhatri_flutter/
    lib/ui/                  theme.dart + shared widgets (the Dhatri* components)
    lib/screens/{patient,caregiver,doctor,shared}/
    lib/care_stream.dart     subscriptions + reconnect + connection state
```

One Flutter app. `Profile.role` chooses the shell (patient, caregiver or doctor). The demo uses three accounts on two phones plus a laptop browser or third device for the doctor.

---

## 3. System overview

```text
 Patient phone        Caregiver phone        Doctor (phone/emulator)
        \                   |                    /
         \---- Serverpod client + one WebSocket ----/
                            |
                       SERVERPOD 4
 ┌───────────────────────────────────────────────────────────┐
 │ Auth        serverpod_auth_idp, email, JWT                 │
 │ Postgres    Profile Prescription Medication DoseEvent      │
 │             WellnessCheck SymptomReport PatientMemory Alert│
 │ pgvector    PatientMemory.embedding (HNSW, cosine)         │
 │ Storage     'private' bucket, prescription photos          │
 │ Future calls extract, remind, escalate, ring               │
 │ Recurring   daily care call per patient (cron)             │
 │ Streams     channel patient_{id} carries CareUpdate        │
 │ Transactions serializable dose state changes               │
 └───────────────────────────────────────────────────────────┘
        |                                  |
 Gemini                               Sarvam AI
 image → draft schedule               saaras  speech → text (hi-IN)
 transcript+context → JSON + Hindi    bulbul:v3  text → speech (hi-IN)
 text → embedding
```

**The one rule every feature follows:** change the row in Postgres, then post a `CareUpdate` to `patient_{id}` through `care_bus.dart`. Every phone that cares about that patient listens to that channel. This is how the missed-dose alert reaches the caregiver live, and how the patient's phone starts a care call.

---

## 4. Data model

Files in `dhatri_server/lib/src/models/`. Times are stored in UTC. **All models below are created in the first migration and frozen on 7 Oct 13:00 IST** so three people can code against the generated client. After the freeze, only BE adds fields, additively.

### Mapping from the summary guide §19

| Guide concept | Built as |
|---|---|
| User / AuthUser, Patient, Caregiver, Doctor | `Profile` with `role` |
| PatientCaregiver, PatientDoctor | `Profile.caregiverId`, `Profile.doctorId` on the patient |
| Prescription, PrescriptionFile | `Prescription` (file path in `path`) |
| Medication, MedicationSchedule | `Medication` (`times` is the schedule) |
| DoseEvent | `DoseEvent` |
| Call, CallAttempt, WellnessCheck | `WellnessCheck` (a call is a check) |
| Symptom, HealthObservation | `SymptomReport` |
| PatientMemory | `PatientMemory` |
| Alert, Notification | `Alert`, plus `CareUpdate` on the stream |
| DoctorInsight | computed `PatientInsight`, not stored |

### Enums

```yaml
enum: Role
values: [patient, caregiver, doctor]
```
```yaml
enum: PrescriptionStatus
values: [uploaded, extracting, extracted, confirmed, failed]
```
```yaml
enum: DoseStatus
values: [scheduled, reminded, taken, missed]
```
```yaml
### pending = ringing on the patient phone. snoozed = "Remind me later".
enum: CheckStatus
values: [pending, active, completed, snoozed]
```
```yaml
enum: CheckTrigger
values: [daily, caregiver]
```
```yaml
enum: AlertKind
values: [missedDose, repeatedSymptom, severeSymptom, patientHelp]
```
```yaml
### Maps to guide §24: attention, important, high.
enum: AlertPriority
values: [attention, important, high]
```
```yaml
enum: TimelineKind
values: [dose, wellness, alert]
```
```yaml
### Drives icon + label + color together. Never color alone.
enum: TimelineTone
values: [good, neutral, warning, missed]
```
```yaml
enum: PatientState
values: [allGood, checkInNeeded, medicationMissed, attention]
```

### Tables

```yaml
class: Profile
table: profile
fields:
  ### session.authenticated.userIdentifier. Null for seeded patients nobody signs in as.
  authUserId: String?
  name: String
  role: Role
  age: int?
  ### Caregiver's number for the patient's "Call caregiver" button.
  phone: String?
  ### Patients only.
  caregiverId: int?, relation(parent=profile)
  doctorId: int?, relation(parent=profile)
  ### Patients only. Shown to the patient; caregiver and doctor type it to link.
  linkCode: String?
indexes:
  profile_auth_idx:
    fields: authUserId
    unique: true
  profile_link_idx:
    fields: linkCode
```

```yaml
class: Prescription
table: prescription
fields:
  patientId: int, relation(parent=profile)
  storageId: String
  path: String
  status: PrescriptionStatus
  ### Raw Gemini JSON for the review screen and debugging.
  extractedJson: String?
  error: String?
  createdAt: DateTime, default=now
```

```yaml
class: Medication
table: medication
fields:
  patientId: int, relation(parent=profile)
  prescriptionId: int, relation(parent=prescription)
  name: String
  strength: String?
  ### "1 tablet"
  doseText: String
  ### "After meals"
  instructions: String?
  ### Local IST times, "HH:mm".
  times: List<String>
  startDate: DateTime
  endDate: DateTime
  active: bool, default=true
```

```yaml
class: DoseEvent
table: dose_event
fields:
  patientId: int, relation(parent=profile)
  medicationId: int, relation(parent=medication)
  scheduledAt: DateTime
  status: DoseStatus
  remindedAt: DateTime?
  takenAt: DateTime?
indexes:
  dose_once_idx:
    fields: medicationId, scheduledAt
    unique: true
  dose_patient_time_idx:
    fields: patientId, scheduledAt
```

```yaml
class: WellnessCheck
table: wellness_check
fields:
  patientId: int, relation(parent=profile)
  status: CheckStatus
  trigger: CheckTrigger
  turnCount: int, default=0
  ### All patient turns, newline-separated.
  transcript: String?
  ### Last Dhatri reply, Hindi.
  replyText: String?
  ### good | okay | low
  mood: String?
  ### One English line for timelines and the doctor view.
  summaryEn: String?
  ### English lines Dhatri recalled for this check. Shown as "What Dhatri remembered".
  memoryUsed: List<String>?
  createdAt: DateTime, default=now
  completedAt: DateTime?
```

```yaml
### One row per symptom per check. Facts live here: "weakness 3 times this week" is a count query.
class: SymptomReport
table: symptom_report
fields:
  patientId: int, relation(parent=profile)
  checkId: int, relation(parent=wellness_check)
  ### weakness, dizziness, fever, pain, nausea, breathlessness, sleep, appetite, other
  symptom: String
  ### 1 mild to 5 severe
  severity: int
  reportedAt: DateTime, default=now
indexes:
  symptom_lookup_idx:
    fields: patientId, symptom, reportedAt
```

```yaml
### Meaning lives here: short English observations, searched by similarity.
### SQL for facts, vectors for context (guide §4).
class: PatientMemory
table: patient_memory
fields:
  patientId: int, relation(parent=profile)
  ### symptom | mood | note
  kind: String
  ### "Patient reported weakness (severity 3) during evening check-in."
  content: String
  sourceCheckId: int?
  createdAt: DateTime, default=now
  ### Dimension must equal GEMINI_EMBED_DIM (768).
  embedding: Vector(768)
indexes:
  memory_patient_idx:
    fields: patientId, createdAt
  memory_embedding_idx:
    fields: embedding
    type: hnsw
    distanceFunction: cosine
```
> The `Vector` field and HNSW index syntax follows Serverpod's vector docs. Verify the exact keywords in spike S3 before the first migration.

```yaml
class: Alert
table: alert
fields:
  patientId: int, relation(parent=profile)
  kind: AlertKind
  priority: AlertPriority
  doseEventId: int?
  symptom: String?
  message: String
  createdAt: DateTime, default=now
  acknowledgedAt: DateTime?
indexes:
  alert_open_idx:
    fields: patientId, acknowledgedAt
```

### Non-table models

```yaml
### Sent on patient_{id}. Exactly one of the four is set.
class: CareUpdate
fields:
  patientId: int
  doseEvent: DoseEvent?
  alert: Alert?
  check: WellnessCheck?
  prescription: Prescription?
```
```yaml
class: UploadTicket
fields:
  path: String
  description: String
```
```yaml
class: MedicationDraft
fields:
  name: String
  strength: String?
  doseText: String
  instructions: String?
  times: List<String>
  durationDays: int
  ### Gemini was unsure. The review screen highlights the row: "Please check this one".
  uncertain: bool
```
```yaml
class: CheckInTurn
fields:
  checkId: int
  turnIndex: int
  text: String
  ### WAV from Sarvam.
  audio: ByteData
  ### True after the last turn. The app shows the closing screen.
  done: bool
```
```yaml
class: TimelineItem
fields:
  at: DateTime
  kind: TimelineKind
  tone: TimelineTone
  title: String
  detail: String?
```
```yaml
class: SymptomCount
fields:
  symptom: String
  count: int
  maxSeverity: int
```
```yaml
### One shape serves the caregiver summary, the doctor dashboard and the patient detail screen.
class: PatientInsight
fields:
  patient: Profile
  ### Null when no dose has come due yet.
  adherencePct: int?
  prevAdherencePct: int?
  dosesTaken: int
  dosesMissed: int
  checkIns: int
  symptoms: List<SymptomCount>
  openAlerts: List<Alert>
  ### Decided by rules in insight_service.dart, never by the model.
  reviewRecommended: bool
  ### 2-3 factual sentences. Written by Gemini from the numbers above; template fallback on failure.
  aiSummary: String
  latestCheck: WellnessCheck?
  generatedAt: DateTime
```
```yaml
### Row on the caregiver and doctor patient lists.
class: PatientStatus
fields:
  patient: Profile
  state: PatientState
  headline: String
  nextDose: DoseEvent?
  openAlerts: int
```

---

## 5. Endpoints

Every endpoint sets `requireLogin => true` and calls `requireAccess(session, patientId, write: bool)` from `services/access.dart` before touching data.

`requireAccess` passes when the caller's `Profile` is that patient, the patient's linked caregiver, or the patient's linked doctor. **The doctor is read-only:** `write: true` calls reject the doctor. Roles live on `Profile` rather than Serverpod scopes, because a changed scope applies only after the user signs in again.

| Endpoint | Method | Caller | Does |
|---|---|---|---|
| `ProfileEndpoint` | `me()` → `Profile?` | all | Current profile, null before onboarding |
| | `register(String name, Role role, int? age, String? phone)` → `Profile` | all | Creates profile; patients get a 6-digit `linkCode` |
| | `link(String code)` → `Profile` | caregiver, doctor | Sets `caregiverId` or `doctorId` on the patient with that code |
| | `myPatients()` → `List<Profile>` | caregiver, doctor | Linked patients |
| | `caregiverContact(int patientId)` → `Profile?` | patient | Caregiver's name and phone |
| `PatientsEndpoint` | `overview()` → `List<PatientStatus>` | caregiver, doctor | Triage list: needs-attention first |
| `PrescriptionEndpoint` | `uploadTicket(int patientId)` → `UploadTicket` | caregiver | `createUploadDescription(storageId: 'private', path: 'prescriptions/{patientId}/{uuid}.jpg')` |
| | `submit(int patientId, String path)` → `Prescription` | caregiver | `verifyUpload`, insert row, schedule `extract` with zero delay |
| | `drafts(int prescriptionId)` → `List<MedicationDraft>` | caregiver | Parsed from `extractedJson` |
| | `confirm(int prescriptionId, List<MedicationDraft> meds)` → `List<Medication>` | caregiver | Inserts medications, creates dose events, schedules `remind` for each |
| `DoseEndpoint` | `today(int patientId)` → `List<DoseEvent>` | all | Today in IST |
| | `markTaken(int doseEventId)` → `DoseEvent` | patient | `transition(scheduled or reminded → taken)`, post update |
| `CheckInEndpoint` | `startNow(int patientId)` → `void` | caregiver | Schedules `CheckInFutureCall.open` with zero delay |
| | `pending(int patientId)` → `WellnessCheck?` | patient | The ringing check, for cold start and reconnect |
| | `accept(int checkId)` → `CheckInTurn` | patient | `pending/snoozed → active`, returns turn 0: Hindi greeting text and audio |
| | `snooze(int checkId)` → `void` | patient | `→ snoozed`, schedules `ring` again in 15 min (max 2 snoozes) |
| | `answer(int checkId, ByteData audio)` → `CheckInTurn` | patient | The pipeline in §7. Returns the next question or the closing line with `done = true` |
| `AlertEndpoint` | `acknowledge(int alertId)` → `Alert` | caregiver | Sets `acknowledgedAt`, post update |
| | `needHelp(int patientId)` → `Alert` | patient | Creates `patientHelp` / `high`, post update ("Something feels wrong") |
| `InsightEndpoint` | `week(int patientId)` → `PatientInsight` | caregiver, doctor | Counts over the last 7 days and the 7 before; AI summary |
| | `timeline(int patientId, int days)` → `List<TimelineItem>` | all | Doses, check-ins and alerts, newest first, max 14 days |
| `CareStreamEndpoint` | `watch(int patientId)` → `Stream<CareUpdate>` | all | Subscribes to `patient_{id}` |
| `DemoEndpoint` | `seed(String token, ...)`, `reset(String token, ...)` | filming only | Off unless `DHATRI_ENABLE_SEED=true`. See `docs/DEMO.md`. Removed after submission |

```dart
class CareStreamEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  Stream<CareUpdate> watch(Session session, int patientId) async* {
    await requireAccess(session, patientId, write: false);
    yield* session.messages.createStream<CareUpdate>('patient_$patientId');
  }
}
```

`services/care_bus.dart` is the only place that posts, so the channel name exists once:

```dart
Future<void> postUpdate(Session s, int patientId, CareUpdate u) =>
    s.messages.postMessage('patient_$patientId', u);
```

---

## 6. Scheduled work

Future calls are stored in Postgres and survive restarts. Accessor names drop the `FutureCall` suffix: `DoseFutureCall` is `futureCalls...dose`.

| Call | Scheduled by | Behaviour |
|---|---|---|
| `PrescriptionFutureCall.extract(prescriptionId)` | `submit()`, zero delay | `uploaded → extracting`, read image from storage, Gemini extraction, store JSON, `→ extracted` (or `failed` with `error`), post update |
| `DoseFutureCall.remind(doseEventId)` | `confirm()`, at `scheduledAt` | `scheduled → reminded` (set `remindedAt`), post update, schedule `escalate` after the grace period |
| `DoseFutureCall.escalate(doseEventId)` | `remind()`, after grace | If still `reminded`: `→ missed`, insert `Alert(missedDose, attention)`, post update |
| `CheckInFutureCall.open(patientId, trigger)` | recurring cron on link (19:00 IST), and `startNow()` | Skip if a `pending/active` check exists. Insert `WellnessCheck(pending)`, post update; the patient phone shows the incoming call. Schedule `ring` after 90 s |
| `CheckInFutureCall.ring(checkId)` | `open()`, `snooze()` | If still `pending` or `snoozed`: re-post the update. After 2 rings with no answer: `snoozed` stays and the caregiver sees "Check-in not answered" on the timeline |

```dart
await session.serverpod.futureCalls
    .callAtTime(event.scheduledAt)
    .dose
    .remind(event.id!);
```

The recurring daily check-in is registered with `callRecurring(identifier: 'checkin-{patientId}')` and a cron of `30 13 * * *` (19:00 IST). Verify the exact API in spike S1.

### Rule 1: every job is safe to run twice

Future calls run at least once, so a crash can repeat a call. Every status change is "move from X to Y, or do nothing". A repeated `escalate` finds `missed`, not `reminded`, and makes no second alert. A repeated `open` finds the existing pending check and does nothing.

### Rule 2: Taken and escalate can race

A patient can tap Taken in the same instant `escalate` fires. `services/dose_rules.dart` runs every status change in a serializable transaction. If Postgres reports a serialization failure, the other side won and this side returns `false`.

```dart
Future<bool> transition(
  Session session,
  int id, {
  required Set<DoseStatus> from,
  required DoseStatus to,
}) async {
  try {
    return await session.db.transaction(
      (tx) async {
        final event = await DoseEvent.db.findById(session, id, transaction: tx);
        if (event == null || !from.contains(event.status)) return false;
        final now = DateTime.now().toUtc();
        await DoseEvent.db.updateRow(
          session,
          event.copyWith(
            status: to,
            takenAt: to == DoseStatus.taken ? now : event.takenAt,
            remindedAt: to == DoseStatus.reminded ? now : event.remindedAt,
          ),
          transaction: tx,
        );
        return true;
      },
      settings: TransactionSettings(isolationLevel: IsolationLevel.serializable),
    );
  } on DatabaseQueryException catch (e) {
    if (e.code == PgErrorCode.serializationFailure) return false;
    rethrow;
  }
}
```

The caller of `transition` reloads the row and posts the update only when it returns `true`.

### Grace period

Environment variable `DHATRI_GRACE_MINUTES`, default `20` (guide §D: reminder at 8:00, escalation by 8:20). Set to `1` while filming.

### Creating dose events

`confirm()` creates every dose event from `startDate` to `startDate + durationDays` (capped at 30 days) for each time in `times`. Times are IST (UTC+5:30, no daylight saving), converted to UTC before insert. Events whose time has already passed today are skipped. The unique index on `(medicationId, scheduledAt)` makes a retried `confirm()` harmless. Dhatri assumes one time zone, IST.

---

## 7. AI and voice

All external calls are made from the server. Keys never reach the phone. Both vendors use `package:http`.

### Secrets and config

`config/passwords.yaml` (gitignored):

```yaml
shared:
  geminiApiKey: '...'
  sarvamApiKey: '...'
  demoSeedToken: '...'
```

Read with `session.serverpod.getPassword('geminiApiKey')`. In production use `SERVERPOD_PASSWORD_geminiApiKey`. Model names are config, never constants, because they change (guide §7): `GEMINI_MODEL`, `GEMINI_EMBED_MODEL`, `GEMINI_EMBED_DIM=768`, `SARVAM_STT_MODEL`, `SARVAM_TTS_MODEL`, `SARVAM_SPEAKER`. Spike S6 confirms the working values on 6 Oct.

### Gemini — `services/gemini.dart`

`POST https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`, header `x-goog-api-key`. Structured output through the JSON schema options in `generationConfig`.

**`extractPrescription(Uint8List image, String mimeType)`** returns:

```json
{
  "unreadable": false,
  "medications": [{
    "name": "Metformin", "strength": "500 mg", "doseText": "1 tablet",
    "instructions": "After meals", "times": ["08:00", "20:00"],
    "durationDays": 30, "uncertain": false
  }]
}
```

Prompt mapping: OD → 08:00, BD → 08:00 and 20:00, TDS → 08:00, 14:00 and 20:00, HS → 22:00. "Before/after food" goes into `instructions`. Set `uncertain: true` for any abbreviation, dose or duration the model is guessing. The caregiver always reviews before anything is scheduled.

**`embed(String text, {bool query})`** returns `List<double>` of length `GEMINI_EMBED_DIM`, using the embedding endpoint with the document or query task type.

**`interpretCheckIn(...)`** takes the context packet (below) and returns:

```json
{
  "mood": "good | okay | low",
  "symptoms": [{ "symptom": "weakness", "severity": 3 }],
  "observationsEn": ["Patient reported weakness, moderate, in the evening."],
  "summaryEn": "Feels weak again; missed no doses today.",
  "replyHi": "आपने कुछ दिन पहले भी कमजोरी की बात कही थी। क्या आज यह ज्यादा है?",
  "needsFollowup": true
}
```

`symptom` is an `enum` in the schema. System rules: Hindi in Devanagari, at most two short sentences, plain words, **never diagnose, never change a dose, never reassure about a symptom**; when severity is 4 or more, tell the patient their caregiver will be informed. Refer to remembered history only when it appears in the packet.

**`summarizeWeek(PatientInsight facts)`** returns 2-3 factual sentences (guide §22): only the supplied numbers, no diagnosis, no causes, plain uncertainty. Example: "Weakness was reported in 3 of 4 check-ins this week. Two doses were missed. Adherence is 86%, down from 92%." The review flag is **not** decided here.

### Context packet (the Patient Memory layer, guide §4 and §11)

```text
current transcript
+ structured state     last 7 days SymptomCount rows, doses taken/missed today and this week (SQL)
+ top-3 memories       PatientMemory for this patient, last 60 days, nearest to the transcript
→ interpretCheckIn
```

### `services/memory_service.dart`

```dart
abstract class MemoryService {
  Future<List<PatientMemory>> retrieve(Session s, int patientId, String query, {int k = 3});
  Future<void> remember(Session s, int patientId, String kind, String content, int checkId);
}
```

`VectorMemoryService`: embeds the query, runs a patient-filtered nearest-neighbour query on `embedding` using cosine distance, ordered by distance, limit `k`. Both the `patientId` filter and a distance cut-off apply, so nothing from another patient or an unrelated note is returned.

`RecencyMemoryService` (fallback): the latest `k` `PatientMemory` rows of kind `symptom`, by `createdAt`. Selected by config `MEMORY_MODE=vector|recency`. Spike S3 and the first Cloud deploy decide which one ships. The check-in works identically either way.

Retrieval happens **before** the current observations are written, so the current message never retrieves itself.

### Sarvam — `services/sarvam.dart` (behind `VoiceEngine`)

Header `api-subscription-key`.

**`transcribe(Uint8List audio)`**: `POST https://api.sarvam.ai/speech-to-text`, multipart `file`, `model` from config, `language_code=hi-IN`. Returns `transcript`. Audio must be under 30 seconds.

**`speak(String text)`**: `POST https://api.sarvam.ai/text-to-speech`, JSON `{ text, language_code: "hi-IN", model, speaker, pace: 0.9 }`. Returns `audios[0]`, base64 WAV, decoded to `ByteData`. Fixed strings (greetings, closings, reminder lines in `copy_hi.dart`) are cached in memory by `(text, speaker)`.

### Care-call pipeline (`CheckInEndpoint.answer`)

```text
audio (AAC, 16 kHz, mono)
  → transcribe (hi-IN)                         if empty: reply "फिर से बताइए" and do not count the turn
  → in parallel: embed(transcript), SQL state  (last 7 days, today's doses)
  → memory.retrieve(top 3)
  → safety_rules.scan(transcript)              deterministic Hindi keyword check
  → gemini.interpretCheckIn(packet)
  → one transaction: update WellnessCheck, insert SymptomReport rows
  → memory.remember(each observationsEn)       embedded, after retrieval
  → symptom_rules: repeat rule, severity rule
  → speak(replyHi)  (or closing line when done)
  → post CareUpdate(check), return CheckInTurn
```

The call has at most `MAX_TURNS` patient turns (default 2). It ends when the turn count is reached or `needsFollowup` is false. The closing line is a fixed string ("धन्यवाद {name} जी। अपना ध्यान रखिए।"). Target latency for one turn is under 8 seconds; the app shows "Thinking…" meanwhile.

### Rules — `services/symptom_rules.dart` and `safety_rules.dart`

**Repeat rule.** For each symptom in the new check:

```dart
final count = await SymptomReport.db.count(
  session,
  where: (t) =>
      t.patientId.equals(patientId) &
      t.symptom.equals(symptom) &
      (t.reportedAt > DateTime.now().toUtc().subtract(const Duration(days: 7))),
);
```

If `count >= 3` and no unacknowledged `repeatedSymptom` alert exists for that symptom, insert `Alert(repeatedSymptom, important, message: 'Weakness reported 3 times in 7 days')` and post it.

**Severity rule.** Any symptom with severity ≥ 4, or any phrase in the emergency list (chest pain, breathlessness, fainting, a fall, in Hindi and Hinglish), inserts `Alert(severeSymptom, high, 'Immediate caregiver review recommended')`. The keyword list is a fixed Dart list in `safety_rules.dart`, so a model miss cannot suppress it. The patient hears that the caregiver is being told; Dhatri gives no medical advice.

### Insight — `services/insight_service.dart`

- `adherencePct = taken / (taken + missed)` over doses whose `scheduledAt` has passed, last 7 days; `prevAdherencePct` for the 7 days before.
- `reviewRecommended = openRepeatedOrSevereAlert || adherencePct < 80 || dosesMissed >= 2`.
- Summary text cached in memory for 5 minutes per `(patientId, hash of facts)`.
- `PatientsEndpoint.overview` states: `attention` if any open `high` alert; `medicationMissed` if a `missedDose` alert is open; `checkInNeeded` if no completed check in 24 h; else `allGood`.

---

## 8. Flutter app

Packages: `serverpod_flutter`, `serverpod_auth_idp_flutter`, `image_picker`, `record`, `just_audio`, `url_launcher`, `path_provider`. P2 only: `flutter_local_notifications`.

Screens, navigation and states are specified in `docs/SCREENS.md`. This section is the wiring.

### `care_stream.dart`

One WebSocket (the Serverpod client shares it). One `watch(patientId)` subscription per linked patient: one for a patient, up to ten for a caregiver or doctor. Exposed as a merged `Stream<CareUpdate>` plus a `ValueListenable<ConnectionState>` (`live`, `reconnecting`, `offline`).

Streams close when the socket drops. On error or done: wait 2 s, resubscribe, then reload (`today()`, `pending()`, `overview()`). A missed update still shows after the gap. The connection state drives the guide §29 banners: "Updated just now", "Reconnecting…", "Offline — showing last known state".

### Optimistic Taken (guide §11, §29)

Tap → the card shows `✓ TAKEN · Saving…` immediately. On success: `Saved`. On network error: `Will sync when connected`, retried every 5 s while the app is open (in memory, not durable). On a `false` result from the server (the dose already became missed): revert to the server state and show "This dose was already marked missed. Your caregiver has been told." Never ask the patient to tap twice.

### Voice recording

Tap to start, never press-and-hold (guide §20). Recording stops on a second tap, after 2 s of silence (amplitude stream below a threshold, never in the first 1.5 s), or at 25 s. Format AAC, 16 kHz, mono. State labels, always as text: `Dhatri is speaking` → `Your turn — speak now` → `Listening` → `Thinking…`.

### Uploads

```dart
final ticket = await client.prescription.uploadTicket(patientId);
final ok = await FileUploader(ticket.description).upload(stream, length);
if (ok) await client.prescription.submit(patientId, ticket.path);
```

`FileUploader.upload` returns `false` without a reason. Show an actionable error with a retry button.

### Auth routing

Sign in with `SignInWidget` (email). Route from `client.auth.authInfoListenable`, not `onAuthenticated`. Then `profile.me()`: null → onboarding; otherwise the shell for `profile.role`.

---

## 9. Configuration and known limits

| Issue | Fix |
|---|---|
| Default `maxRequestSize` is 512 KiB; photos and audio exceed it | `maxRequestSize: 5242880` in `development.yaml` and `production.yaml`. Photos: `maxWidth: 1600, imageQuality: 80`. Audio: AAC, 16 kHz, mono |
| Sarvam REST speech-to-text accepts under 30 seconds | Stop recording at 25 s |
| Handwriting is misread | Use printed prescriptions in the video. The review screen is the safety net |
| Time zones | Store UTC. Medication times are IST. Convert at the edge |
| Future calls repeat | Guarded status transitions (§6) |
| Reminders reach the patient only while the app is open | Stated plainly in the writeup. P2: local notifications scheduled on the device |
| Email sign-up needs verification codes | In development, log the code on the server. In production, read it from Serverpod Cloud logs when creating the three demo accounts |
| Doctor sign-up is unverified | Hackathon only. A real release needs credential checks |
| Secrets | `passwords.yaml` is gitignored. Share keys privately |
| pgvector might not exist on Serverpod Cloud | `MEMORY_MODE=recency` fallback (§7) |

### Health-safety posture (guide §12, §22)

Dhatri assists and routes; it does not diagnose. Patient-facing screens never show "AI says" about a condition. The Help tab says "In an emergency, call 112." Summaries state facts and counts only.

---

## 10. Tests

`test/integration/` with Serverpod's test tools:

1. `dose_escalation_test.dart` — a dose never taken becomes `missed` after `escalate`, with exactly one alert, even when `escalate` runs twice.
2. Same file — a dose marked taken before `escalate` stays `taken`, with no alert.
3. Same file — `markTaken` and `escalate` run concurrently 20 times; the final state is either `taken` with no alert, or `missed` with one alert, never both.
4. `symptom_rules_test.dart` — three weakness reports in 7 days create one `repeatedSymptom` alert; a fourth creates no second one; a severity-4 report creates one `severeSymptom` alert.
5. `access_test.dart` — a caregiver not linked to a patient is rejected on every endpoint; the doctor is rejected on every write.
6. `memory_test.dart` — retrieval for patient A never returns patient B's memories; with seeded weakness memories, a "I feel weak again" query returns them (`vector` mode), and the recency fallback returns the same rows.

Flutter: `flutter analyze` clean, plus one widget test per shared `Dhatri*` component at text scale 2.0 (no overflow).

---

## 11. Deployment

- **Server:** Serverpod Cloud with the hackathon credits. Files use Cloud storage through the `ServerpodCloudProvider` in the generated `server.dart`. **First deploy rehearsal on 9 Oct**, because it also answers the pgvector question.
- **Judges' build:** Android APK pointed at the Cloud server, plus three demo accounts (patient, caregiver, doctor) in the README.
- **Run locally:** `serverpod start` runs the server, an embedded Postgres and the Flutter app with hot reload. The local Postgres must have the `pgvector` extension (Serverpod's template Docker image includes it).
- **Spikes S1-S6** (list in `PLAN.md` day zero) confirm every Serverpod and vendor API name in this file against current docs. If a name here is wrong, fix the doc in the same PR as the code.
