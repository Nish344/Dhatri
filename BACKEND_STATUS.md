# Dhatri backend status (7 Oct 2026)

WhatsApp **Lazy Monks**: frontend is done; **Prajwal + Nishanth** own **backend + AI**. Repo: https://github.com/Nish344/Dhatri

## Done today

- Serverpod 4 scaffold: `dhatri_server/`, `dhatri_client/`, workspace root `pubspec.yaml`
- All models from `ARCHITECTURE.md` §4 (first migration `20261007085210332`, includes pgvector HNSW on `PatientMemory`)
- Endpoint stubs from §5 (`Profile`, `Patients`, `Prescription`, `Dose`, `CheckIn`, `Alert`, `Insight`, `CareStream`, `Demo`)
- `care_bus.dart`; `CareStreamEndpoint.watch` wired to `patient_{id}` channel
- `development.yaml` `maxRequestSize: 5242880` for prescription photos / voice

## Tests (`dart test` in `dhatri_server/`)

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
cp config/passwords.yaml.example config/passwords.yaml  # if example exists; add gemini/sarvam keys
serverpod start
```

Flutter app (mock mode until client wired): `cd dhatri_flutter && flutter run`.
