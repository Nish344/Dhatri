# Testing & debugging Dhātrī

How to verify frontend, backend, and AI after pulling `main`, and how to read the new server logs when something breaks.

---

## 1. One-time setup

```bash
cd ~/Projects/serverpod   # or your clone path
cp dhatri_server/config/passwords.yaml.example dhatri_server/config/passwords.yaml
```

Edit `dhatri_server/config/passwords.yaml` (gitignored):

| Field | Required for | Notes |
|-------|----------------|-------|
| `shared.geminiApiKey` | Rx extract, check-in AI, embeddings, week summary | Empty → Gemini calls fail with HTTP 403 |
| `shared.sarvamApiKey` | Hindi STT/TTS on care calls | Empty → TTS falls back to silent text; STT fails |
| `shared.demoSeedToken` | `DemoEndpoint.seed` / `reset` | Match what the Flutter demo toolbar sends |
| `development.*` | Local server | Keep long random strings as in the example |
| `test.*` | `dart test` integration | Separate from development |

Optional env overrides (AI smoke / server):

```bash
export GEMINI_MODEL=gemini-3.5-flash-lite   # default
export SARVAM_STT_MODEL=saaras:v3
export SARVAM_TTS_MODEL=bulbul:v3
export MEMORY_MODE=recency                  # if pgvector unavailable
export DHATRI_ENABLE_SEED=true
export DHATRI_GRACE_MINUTES=1               # faster missed-dose demos
```

Install deps once from the workspace root:

```bash
flutter pub get
```

---

## 2. Start the stack

```bash
cd dhatri_server
serverpod start
```

This boots Postgres (embedded for local/test), applies migrations, hot-reloads server + Flutter, and watches for codegen. Press `Q` to quit.

Do **not** commit `config/passwords.yaml` or any file that holds real API keys.

---

## 3. Automated checks (no UI)

### Server unit + integration

```bash
cd dhatri_server
dart analyze
dart format --set-exit-if-changed .
dart test
```

Integration tests start their own embedded DB from `config/test.yaml` — Docker is not required.

### Flutter static check

```bash
cd dhatri_flutter
dart analyze
```

Expect **no errors**. Remaining infos (e.g. `withOpacity` deprecations) are non-blocking.

---

## 4. Live AI smoke (Gemini + Sarvam)

No database required. Keys are read from `config/passwords.yaml` `shared.*`, or from `GEMINI_API_KEY` / `SARVAM_API_KEY`.

```bash
cd dhatri_server

# Prescription vision
dart run bin/ai_smoke.dart extract samples/simple_metformin.jpg

# Check-in interpretation (Hindi transcript → JSON + replyHi)
dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"

# Sarvam TTS → STT round trip (writes greeting.wav; safe to delete)
dart run bin/ai_smoke.dart voice

# Embeddings
dart run bin/ai_smoke.dart embed

# Optional gates
dart run bin/ai_smoke.dart gate samples/
```

**Healthy output looks like:**

- `extract`: `unreadable: false` and named medicines with times
- `checkin`: JSON with `mood`, `symptoms`, Devanagari `replyHi`
- `voice`: WAV size > 0 and a Hindi transcript
- `embed`: `dims: 768`

**If extract/checkin return HTTP 403:** API key missing or invalid in `passwords.yaml`.

---

## 5. Manual app flows

After `serverpod start`, use the Flutter app (launched with it or via spawn).

### Auth & roles

1. Register three accounts (patient / caregiver / doctor) or use demo seed accounts — see [DEMO.md](DEMO.md).
2. Patient shows a **link code**; caregiver/doctor **link** with that code.
3. Role switcher should land on the matching shell.

### Caregiver — prescription

1. Upload a clear Rx photo (`samples/*.jpg` work as fixtures).
2. Wait for status `extracted` (future call runs immediately after submit).
3. Review drafts (uncertain rows flagged) → **Confirm**.
4. Dose reminders are scheduled; caregiver overview / patient meds update via care stream.

### Patient — dose & check-in

1. Home shows today’s doses; **Mark taken** clears the reminder path.
2. Caregiver **Start check-in** (or wait for evening cron `30 13 * * *` UTC = 19:00 IST).
3. Patient: accept call → greeting audio/text → answer by voice **or** Hindi tap `answerText`.
4. Caregiver timeline/alerts update; severe / emergency phrases raise high-priority alerts.

### Doctor

1. Open clinical portal for a linked patient.
2. Confirm adherence %, symptom frequency, AI week summary, open alerts.

---

## 6. Reading backend logs

The server now emits structured `session.log` lines. Filter the `serverpod start` console (or MCP `tail_server_logs`) for these prefixes:

| Prefix | Meaning |
|--------|---------|
| `endpoint.checkIn.*` / `endpoint.rx.*` / `endpoint.dose.*` | API entry |
| `futureCall.checkIn.*` / `futureCall.rx.*` / `futureCall.dose.*` | Scheduled work started |
| `checkIn.open` / `ring` / `snooze` / `accept` | Call lifecycle |
| `checkIn.stt` | Sarvam STT timing + empty transcript |
| `checkIn.gemini` | Interpret latency, mood, symptom count, follow-up |
| `checkIn.tts` | Sarvam TTS size + ms (or warning on failure) |
| `checkIn.turnDone` | Turn finished: `done`, `severe`, status |
| `checkIn.memory` | Embedding store / skip |
| `rx.extract` | File load → Gemini → draft count / fail reason |
| `rx.confirm` | Meds + dose events created |
| `dose.remind` / `dose.escalate` / `dose.taken` | Reminder pipeline |
| `insight.summary` | Gemini week summary or template fallback |
| `profile.register` / `profile.link` | Onboarding |

**Debug recipes**

| Symptom | What to look for |
|---------|------------------|
| Rx stuck on uploaded | No `futureCall.rx.extract` / `rx.extract start` — future calls or storage |
| Rx failed | `rx.extract fileMissing` or `extraction failed` / `unreadable=true` |
| Silent greeting | `Text-to-speech failed` warning; check `sarvamApiKey` |
| Patient hears “say again” | `checkIn.stt … empty=true` — mic / STT; try `answerText` |
| No memory recall | `Memory retrieval failed` or `MEMORY_MODE=recency`; embeddings need Gemini |
| Missed-dose alert never fires | `dose.remind` then later `dose.escalate`; check `DHATRI_GRACE_MINUTES` |
| Check-in never rings | `checkIn.open` then `checkIn.ring`; max 2 rings then snoozed |

---

## 7. Migrations & codegen

After changing `.spy.yaml` models with tables:

1. Prefer Serverpod MCP `create_migration` + `apply_migrations` while the server is running.
2. Fallback: `cd dhatri_server && serverpod create-migration` (add `--force` only for destructive schema).
3. Never hand-edit generated Dart under `lib/src/generated/` or `dhatri_client/` — change models/endpoints and regenerate.
4. `serverpod start` applies pending migrations on boot.

If the DB drifts: MCP `create_repair_migration`.

---

## 8. Quick health checklist

Before a push or demo:

- [ ] `passwords.yaml` has non-empty Gemini + Sarvam keys (local only)
- [ ] `cd dhatri_server && dart test` — all green
- [ ] `cd dhatri_flutter && dart analyze` — no errors
- [ ] `dart run bin/ai_smoke.dart extract samples/simple_metformin.jpg`
- [ ] `dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"`
- [ ] `dart run bin/ai_smoke.dart voice`
- [ ] `serverpod start` — register/link → upload Rx → confirm → start check-in → answer
- [ ] Logs show `rx.extract done` and `checkIn.turnDone` without error-level lines

For filmed demo accounts, seed toggles, and scene order, see [DEMO.md](DEMO.md).
