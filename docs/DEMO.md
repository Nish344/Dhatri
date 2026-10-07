# Dhatri demo video and seed data

**Disclosure:** Doses, check-ins, symptoms and patient memories shown in the demo video include **seeded history** created by `DemoEndpoint.seed` (or the Flutter mock engine before backend wiring). Only the upload → confirm and live alert scenes use actions recorded during filming unless noted.

**Deadline:** Submit by **14 Oct 2026, 18:00 IST**. Video **under 2:00**, public YouTube/Vimeo, no copyrighted music.

---

## Demo accounts (create on Serverpod Cloud after deploy)

| Role | Suggested email | Notes |
|------|-----------------|-------|
| Patient | `ramesh.demo@dhatri.local` | Ramesh Kumar, 72, link code **482910** |
| Caregiver | `ananya.demo@dhatri.local` | Daughter; links with `482910` |
| Doctor | `priya.demo@dhatri.local` | Read-only; links with same code |

Film with **two phones** (patient + caregiver) side by side for the missed-dose alert scene.

---

## Filming toggles

```bash
export DHATRI_ENABLE_SEED=true
export DHATRI_GRACE_MINUTES=1   # escalation ~1 min while recording
```

Seed token: value of `shared.demoSeedToken` in `config/passwords.yaml` (never commit).

```dart
// After login as caregiver on Cloud:
await client.demo.seed('<demoSeedToken>');
// Between takes:
await client.demo.reset('<demoSeedToken>');
```

---

## Seeded story (Ramesh Kumar)

Matches the Flutter mock narrative and `demo_seed.dart`:

- **7 days** of Metformin (08:00, 20:00), Amlodipine (08:00), Atorvastatin (22:00).
- **Today:** morning doses **taken**; evening Metformin **reminded** (hero “next dose” for Scene 2).
- **Weakness** reported on check-ins **3 days ago** and **yesterday** (severity 2 → 3); **Patient Memory** rows include embeddings for vector recall.
- **Repeated weakness** alert open for caregiver triage.
- **Adherence ~86%** (down from ~92%) for doctor Scene 6.

---

## Video scene order (≤ 2 minutes)

1. **Caregiver — upload & review:** Sample Rx photo → extraction → human review → **Confirm schedule**.
2. **Patient — reminder:** Dominant next-dose card (evening Metformin).
3. **Missed dose & live alert:** Grace expires → caregiver sees **missed dose** alert (both phones in one shot).
4. **Caregiver:** Tap **Call patient** / initiate check-in.
5. **Patient — Hindi care call:** Answer → weakness → Dhatri **recalls earlier weakness** from memory → closing line.
6. **Doctor — dashboard:** Adherence, 3× weakness, AI summary, review flag.

Spoken Hindi lines: see `dhatri_flutter/README.md` and `copy_hi.dart`.

---

## AI tool disclosure (submission writeup)

Disclose use of **Gemini** (prescription extraction, check-in interpretation, embeddings, weekly summary), **Sarvam** (Hindi STT/TTS), and any coding assistants used during the hackathon.

---

## Known limits (state in writeup)

- Reminders and care calls are **in-app**, not PSTN/Exotel.
- Patient reminders need the app **open** (no FCM in scope).
- Seeded timeline data is **disclosed** above.
