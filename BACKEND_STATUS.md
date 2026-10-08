# Dhatri backend + AI status (8 Oct 2026)

WhatsApp **Lazy Monks**. Repo: https://github.com/Nish344/Dhatri

## Final-ready (BE + AI)

Server and AI work for P0/P1 is in place on branch `be-ai/final-ready` (do not confuse with Flutter wiring — still APP).

### Fixed today

- **Regenerated** `CheckIn` + `Prescription` into `endpoints.dart` / `protocol.yaml` / `dhatri_client` (they had been dropped from the last generate)
- **`CheckInFutureCall.open` / `ring`** — open posts pending check + schedules ring at 90 s; ring re-posts; after 2 unanswered rings → snoozed + timeline "Check-in not answered"
- **Daily check-in** registered on caregiver/doctor `link` (`cron 30 13 * * *` = 19:00 IST)
- **`snooze`** uses `snoozeCount` (max 2), schedules ring in 15 min
- Additive migration `20261008074806539-wellness-ring-snooze-counts` (`ringCount`, `snoozeCount`)
- **`CheckIn.answerText`** — Hindi tap-to-answer fallback (same pipeline, no STT)
- Fixed **`istTimeToUtc`** (dose schedule times were wrong on non-IST hosts)

### AI (complete)

- Gemini extract / embed / interpret / week summary (`gemini-3.5-flash-lite` default)
- Sarvam STT/TTS behind `VoiceEngine`
- Care-call pipeline, memory (vector + recency), safety + symptom rules
- Demo seed + `docs/DEMO.md` + samples; live gates 5/5 extract and BhavVaani STT
- `bin/ai_smoke.dart` (keys from `config/passwords.yaml` shared.*)

### BE endpoints (all registered)

| Endpoint | Status |
|---|---|
| Profile | me, register, link (+ daily check-in), myPatients, caregiverContact |
| Prescription | uploadTicket, submit → extract FC, drafts, confirm → doses + remind |
| Dose | today, markTaken; DoseFutureCall remind / escalate |
| CheckIn | startNow, pending, accept, snooze, answer, answerText; FC open / ring |
| Alert | acknowledge, needHelp |
| Insight | week, timeline |
| Patients | overview |
| CareStream | watch |
| Demo | seed / reset (`DHATRI_ENABLE_SEED` + token) |

### Still out of BE/AI scope

- Flutter → `dhatri_client` (APP)
- Serverpod Cloud deploy rehearsal (needs Cloud project + credits)
- Native-speaker Hindi copy polish (optional)

## Tests

```bash
cd dhatri_server
# needs config/passwords.yaml (see passwords.yaml.example)
dart test
```

## Run locally

```bash
export PATH="$HOME/flutter/bin:$HOME/.pub-cache/bin:$PATH"
cd dhatri_server
cp config/passwords.yaml.example config/passwords.yaml  # fill AI keys + demoSeedToken
serverpod start   # applies pending migrations on boot
```

AI smoke:

```bash
cd dhatri_server
dart run bin/ai_smoke.dart gate samples
dart run bin/ai_smoke.dart voice
dart run bin/ai_smoke.dart checkin "आज फिर कमजोरी लग रही है"
```
