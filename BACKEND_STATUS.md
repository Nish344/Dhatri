# Dhatri backend status (7 Oct 2026)

WhatsApp **Lazy Monks**: frontend is done; **Prajwal + Nishanth** own **backend + AI**. Repo: https://github.com/Nish344/Dhatri

## Done today

- Serverpod 4 scaffold: `dhatri_server/`, `dhatri_client/`, workspace root `pubspec.yaml`
- All models from `ARCHITECTURE.md` §4 (first migration `20261007085210332`, includes pgvector HNSW on `PatientMemory`)
- Endpoint stubs from §5 (`Profile`, `Patients`, `Prescription`, `Dose`, `CheckIn`, `Alert`, `Insight`, `CareStream`, `Demo`)
- `care_bus.dart`; `CareStreamEndpoint.watch` wired to `patient_{id}` channel
- `development.yaml` `maxRequestSize: 5242880` for prescription photos / voice

## AI track (7 Oct — complete for Wed gate)

- `services/gemini.dart` — default model `gemini-3.5-flash-lite` (override with `GEMINI_MODEL`)
- Sarvam + check-in pipeline, memory, insights, prescription extraction future call
- **`docs/DEMO.md`** — video scenes, seed disclosure, demo accounts
- **`services/demo_seed.dart`** + **`DemoEndpoint.seed/reset`** (requires `DHATRI_ENABLE_SEED=true` + `demoSeedToken`)
- **`samples/`** — 5 synthetic Rx JPGs + `expected.json`; **`dart run bin/ai_smoke.dart gate samples`** (live: **5/5** on 7 Oct)
- Live smoke (Gemini on `project1-434615`, billing **off**): `embed`, `checkin`, `gate` verified

Live Sarvam (7 Oct): `voice` round-trip OK; `bhavvaani` STT gate **5/5** on BhavVaani train WAVs (`test_fixtures/bhavvaani_stt.json`, data under `~/mlchall/kaggle1`). Keys auto-read from `config/passwords.yaml` shared.* in `ai_smoke`.

For BE to hook up:

- `submit()`: `await session.serverpod.futureCalls.callWithDelay(Duration.zero).prescription.extract(p.id!);`
- `CheckIn.startNow/snooze` and `CheckInFutureCall.open/ring` (Sat)

## Tests (`dart test` in `dhatri_server/`)

`dart test` — **28 tests**, integration needs `config/passwords.yaml` (see `config/passwords.yaml.example`).

- `test/unit/ai_test.dart`
- `test/integration/check_in_test.dart`, `demo_seed_test.dart`, dose/symptom/access/memory tests

## Backend core (7 Oct evening)

- `ProfileEndpoint` register / link / myPatients / caregiverContact
- `PrescriptionEndpoint` upload ticket, submit → extract future call, confirm → doses
- `DoseFutureCall` remind + escalate; `DoseEndpoint.today`, `markTaken`
- `AlertEndpoint`, `InsightEndpoint.timeline`, `PatientsEndpoint.overview`
- `CheckIn.startNow` / snooze (caregiver-triggered pending check)

## Next (APP)

1. Wire Flutter to `dhatri_client` (replace mock repository behind a flag)
2. Sign-in, onboarding, `FileUploader`, real care stream

## Run locally

```bash
export PATH="$HOME/flutter/bin:$HOME/dart-sdk/dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
cd dhatri_server
cp config/passwords.yaml.example config/passwords.yaml  # fill shared AI keys + demoSeedToken
serverpod start
```

AI spike S6 (no server):

```bash
cd dhatri_server
export GEMINI_API_KEY=...   # optional: already in passwords.yaml shared.geminiApiKey
export GEMINI_MODEL=gemini-3.5-flash-lite
dart run bin/ai_smoke.dart gate samples
dart run bin/ai_smoke.dart embed
dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"
dart run bin/ai_smoke.dart voice   # needs SARVAM_API_KEY
```

Flutter app (mock mode until client wired): `cd dhatri_flutter && flutter run`.
