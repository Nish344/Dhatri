# Dhatri backend status (7 Oct 2026)

WhatsApp **Lazy Monks**: frontend is done; **Prajwal + Nishanth** own **backend + AI**. Repo: https://github.com/Nish344/Dhatri

## Done today

- Serverpod 4 scaffold: `dhatri_server/`, `dhatri_client/`, workspace root `pubspec.yaml`
- All models from `ARCHITECTURE.md` §4 (first migration `20261007085210332`, includes pgvector HNSW on `PatientMemory`)
- Endpoint stubs from §5 (`Profile`, `Patients`, `Prescription`, `Dose`, `CheckIn`, `Alert`, `Insight`, `CareStream`, `Demo`)
- `care_bus.dart`; `CareStreamEndpoint.watch` wired to `patient_{id}` channel
- `development.yaml` `maxRequestSize: 5242880` for prescription photos / voice

## AI track (Nishanth, branch `ai/gemini-sarvam-pipeline`, 7 Oct)

Done, tested with faked vendors (no keys needed for tests):

- `services/gemini.dart` — `extractPrescription`, `embed`, `interpretCheckIn` (context packet), `summarizeWeek`; prompts and JSON schemas live here. `parseDrafts` validates times/duration and flags guesses as `uncertain`
- `services/sarvam.dart` behind `voice_engine.dart` — `transcribe` (`saaras:v3`), `speak` (`bulbul:v3`, cached)
- `services/memory_service.dart` — vector mode now really embeds the query; 60-day window and cosine cut-off 0.5; `memoryServiceFor(gemini)` picks by `MEMORY_MODE`
- `services/check_in_service.dart` — full care-call pipeline (§7): empty transcript asks again, Gemini outage still closes the call, emergency words force a `severeSymptom` alert and end the call
- `services/safety_rules.dart`, `copy_hi.dart`, `insight_service.dart` (week facts, review flag, AI summary with template fallback, 5-min cache)
- `services/prescription_extraction.dart` + `future_calls/prescription_future_call.dart`
- Endpoints: `CheckIn.pending/accept/answer`, `Prescription.drafts`, `Insight.week`
- `bin/ai_smoke.dart` — live check of keys/models and the 5-sample extraction gate

For BE to hook up:

- `submit()`: `await session.serverpod.futureCalls.callWithDelay(Duration.zero).prescription.extract(p.id!);`
- `CheckIn.startNow/snooze` and `CheckInFutureCall.open/ring` are still stubs (BE, Sat)

Not done yet: live run with real keys, the 5 sample prescriptions, seed data with embeddings (`docs/DEMO.md` does not exist yet).

## Tests (`dart test` in `dhatri_server/`)

`dart test` runs unit and integration tests; integration needs `config/passwords.yaml` (see `config/passwords.yaml.example`), otherwise it exits silently.

- `test/unit/ai_test.dart` — extraction parsing, safety phrases, Gemini/Sarvam request shapes, summary template
- `test/integration/check_in_test.dart` — memory recall, emergency alert, Gemini outage, silence, weekly insight

Integration tests from `ARCHITECTURE.md` §10:

- `test/integration/dose_escalation_test.dart` — escalate idempotency, taken vs missed race
- `test/integration/symptom_rules_test.dart` — repeat + severity alerts
- `test/integration/access_test.dart` — access matrix + dose/alert endpoints
- `test/integration/memory_test.dart` — recency scope + vector nearest-neighbour

## Next (PLAN Wed 7 Oct)

1. Implement `requireAccess` + `ProfileEndpoint` (auth → profile, link codes)
2. `PrescriptionEndpoint` upload + `PrescriptionFutureCall.extract` (Gemini)
3. `confirm` → dose events + `DoseFutureCall.remind` / `escalate` + `dose_rules.dart`
4. Wire Flutter to `dhatri_client` (replace mock repository behind a flag)

## Run locally

```bash
export PATH="$HOME/flutter/bin:$HOME/dart-sdk/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
cd dhatri_server
cp config/passwords.yaml.example config/passwords.yaml  # then fill in random values and the AI keys
serverpod start
```

AI keys without the server (spike S6):

```bash
cd dhatri_server
export GEMINI_API_KEY=... SARVAM_API_KEY=...
dart run bin/ai_smoke.dart extract samples/*.jpg
dart run bin/ai_smoke.dart voice
dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"
dart run bin/ai_smoke.dart embed
```

Flutter app (mock mode until client wired): `cd dhatri_flutter && flutter run`.
