# Dhatri — Team Plan

Four people, eight days. Technical detail is in `ARCHITECTURE.md`, screens in `docs/SCREENS.md`, the video and seed data in `docs/DEMO.md`, scope reasoning in `docs/DECISIONS.md`.

**Deadline:** 14 October 2026, 23:59 CEST = **15 October, 03:29 IST**. We submit by **14 October, 18:00 IST** and do not use the last night.

---

## 1. What we are building

A caregiver photographs a prescription. Dhatri turns it into reminders. The caregiver's phone alerts live when a dose is missed. A Hindi care call checks how the patient feels and remembers what they said before. The caregiver and the doctor see what changed, in a few factual lines.

### Tiers

| Tier | Items | Gate |
|---|---|---|
| **P0 core loop** | 1 Sign-in with three roles. 2 Upload prescription photo. 3 AI extraction. 4 Caregiver reviews and confirms. 5 Dose events scheduled. 6 Patient reminder and Taken. 7 Unanswered reminder becomes missed. 8 Caregiver phone alerts live. 9 Basic health timeline. 10 Tap-to-call | Fri 9 Oct evening |
| **P1 differentiators** | 11 In-app Hindi care call (voice in, voice out). 12 Symptoms stored, repeat rule flags 3 in 7 days. 13 Patient Memory: the reply recalls earlier weakness. 14 Weekly insight with factual AI summary. 15 Read-only doctor dashboard. 16 Caregiver triage list | Sat 10 Oct evening (11-13), Sun 11 Oct 20:00 freeze (14-16) |
| **P2 stretch** | Local dose notifications on the patient phone. Caregiver plays back the patient's answer | Only if P1 passed, before freeze |

**Not building:** Exotel phone calls, Piper, IndicF5, push (FCM), durable offline sync, doctor write actions, payments, chat. Reasons in `docs/DECISIONS.md`.

### How we are judged

| Criterion | Weight | What it means for us |
|---|---|---|
| Does it work | 30% | Steps 1-13 run on real phones with nothing faked. Seeded history is disclosed. Also the tie-breaker |
| Use of the Serverpod stack | 25% | Auth, Postgres, file storage, future calls, a recurring task, streams, serializable transactions and pgvector all do real work |
| Craft and technical creativity | 25% | Race-safe dose states, jobs safe to repeat, SQL for facts plus vectors for context, accessible UI, a clean review screen |
| Usefulness | 20% | Ramesh, 72, alone, and his daughter in another city. Patient, caregiver and doctor each get what they need |

Judges may score from the video and writeup alone and stop watching at 2 minutes. Scene order in `docs/DEMO.md` is built for that.

---

## 2. Team and ownership

Each track has one owner who decides and merges for that area. Fill in names.

| Track | Owner | Owns |
|---|---|---|
| **BE: Backend core** | _name_ | Scaffold, auth, all models and migrations, `access.dart`, profile and linking, prescription upload and `confirm`, dose scheduling, future calls, `dose_rules.dart`, `care_bus.dart`, care stream, `InsightEndpoint.timeline`, `PatientsEndpoint`, `DemoEndpoint`, integration tests, Serverpod Cloud deploy |
| **AI: AI and voice** | _name_ | `gemini.dart`, `sarvam.dart`, `voice_engine.dart`, `memory_service.dart`, prompts and schemas, `extract` body, check-in endpoints and pipeline, `symptom_rules.dart`, `safety_rules.dart`, `insight_service.dart`, `copy_hi.dart`, sample prescriptions, seed data (with embeddings) |
| **APP-P: Patient app, shell and UI kit** | _name_ | Flutter project, `lib/ui/` theme and shared components, sign-in, onboarding, role routing, `care_stream.dart`, all patient screens, then the doctor screens |
| **APP-C: Caregiver app and story** | _name_ | Caregiver screens (home, patient detail, alert detail, upload, review, summary), video script, recording and editing, README, writeup, build post |

Pairing when blocked: BE with APP-P on streams and auth; AI with APP-C on review and summary.

### Shared rules

- The models and endpoint signatures in `ARCHITECTURE.md` §4 and §5 are the contract. A change needs a message in team chat first, because three people code against it.
- **Model freeze: Wed 7 Oct 13:00 IST.** All tables, including `PatientMemory` and the vector index, exist in the first migration. After that BE adds fields additively.
- Every screen follows `docs/SCREENS.md` and passes the checklist in `AGENTS.md` before merge. Shared widgets live in `lib/ui/` only; propose additions in chat.

---

## 3. Day zero (Tue 6 Oct, evening)

1. **Everyone:** register on the BuilderBase event page and join one team (max 4). Choose a Representative who submits.
2. **Everyone:** install Flutter, or Serverpod App Studio.
3. **BE:** create the GitHub repo (the hackathon site can create a private one under Serverpod's organisation). If we use our own, share it with viktor@serverpod.dev, alexander@serverpod.dev and isak@serverpod.dev before submitting.
4. **BE:** `serverpod create dhatri`, commit, push. Add `config/passwords.yaml` to `.gitignore`. Copy these docs into the repo as laid out in `ARCHITECTURE.md` §2.
5. **AI:** create Gemini and Sarvam keys. Share privately.
6. **Everyone:** clone, run `serverpod start`, see the template app talk to the server.

### Spikes (each one a throwaway script or branch, answer in the team chat before 7 Oct 13:00)

| Spike | Owner | Question | If the answer is no |
|---|---|---|---|
| S1 | BE | Do `callAtTime`, `callWithDelay` and `callRecurring(...).cron` exist with the names in ARCHITECTURE §6? | Fix the doc to the real names |
| S2 | BE + APP-P | Does a message posted from a future call reach two phones through `createStream`? | Fall back to polling `today()` every 3 s as a stopgap and report to Serverpod as feedback |
| S3 | BE | Do `Vector(768)`, the HNSW index and a patient-filtered distance query work locally? Is `pgvector` available on Serverpod Cloud (ask, or deploy a hello-world with a vector table)? | Ship `MEMORY_MODE=recency`; keep the vector code behind the interface |
| S4 | BE + APP-C | Does `FileUploader` to the `private` bucket work from a phone, and can `extract` read the file back? | Raise `maxRequestSize`; ask on the hackathon channel |
| S5 | BE | Does the serializable transaction return the error code we catch? | Adjust `dose_rules.dart` and its test |
| S6 | AI | Working Gemini model id, embedding model id and dimension; Sarvam STT model id and AAC acceptance; TTS speaker; one Hindi round trip in a plain script | Update the config defaults and ARCHITECTURE §7 |

---

## 4. Working agreement

- `main` always runs. Branches: `be/...`, `ai/...`, `app-p/...`, `app-c/...`. Small pull requests, merged the same day, one reviewer.
- **Only BE creates migrations.** Others propose model changes in chat.
- After a model or endpoint change, run code generation and commit the regenerated `dhatri_client` in the same PR.
- `passwords.yaml` is never committed.
- 15-minute standup at 10:00 IST: yesterday, today, blocked.
- Keep a shared **feedback log** of every Serverpod bug, confusing doc and missing feature. It becomes the Most Valuable Feedback entry.
- Never run a global find-and-replace on a word like "Dose" or "Dhatri". It already corrupted one guide.

---

## 5. Schedule

Gates are checked at the evening standup. A failed gate changes the next morning's plan; the cut order is in §8.

### Tue 6 Oct — scaffold and spikes

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Day-zero setup. Email sign-in. **All models** from ARCH §4, first migration. Spikes S1, S3, S5 | Keys. Spike S6. Dart script: Gemini reads a prescription photo and prints JSON | Flutter runs against the local server. Spike S2 with BE | Collect 5 printed prescriptions (2 simple, 2 multi-drug, 1 hard). Draft the video script from `docs/DEMO.md`. Spike S4 |

### Wed 7 Oct — contract and kit

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| **By 13:00:** every endpoint in ARCH §5 exists with real signatures and placeholder bodies; models frozen; client regenerated. Then `requireAccess`, profile, `link`, upload ticket, `submit` | Extraction schema and prompt tuned on the 5 samples. `sarvam.dart` speak and transcribe in a script | `lib/ui/`: theme, tokens, text-scale test harness, PrimaryButton, SecondaryButton, StatusChip, SectionHeader, EmptyState, ErrorState, BottomActionBar. Sign-in, onboarding, role routing | Caregiver home layout (static data). Upload screen with `image_picker` and `FileUploader` |

**Gate (end of day):** extraction correct on at least 4 of 5 samples. If not, the review screen opens with empty rows the caregiver fills in, and extraction becomes a prefill. Nothing else changes.

### Thu 8 Oct — schedule and escalation

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| `confirm()` creates dose events. `remind` and `escalate`. `dose_rules.transition`. Tests 1-3 | `extract` body wired into `PrescriptionFutureCall`. Sarvam STT tested with recorded Hindi | Patient Home (dominant next-dose card, today list), Medicines tab, optimistic Taken. MedicationCard | Review screen: banner, cards, full-screen edit, confirm. Real "reading" state from status |

### Fri 9 Oct — live on two phones, and a first deploy

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Care stream and `postUpdate` on every state change. **First Serverpod Cloud deploy rehearsal** (answers the pgvector question). `timeline` endpoint | `CheckInEndpoint` single turn: greeting, answer, STT, Gemini, TTS, no memory yet. `copy_hi.dart` | `care_stream.dart` with reconnect and connection banners. Home updates on `reminded`. Incoming Care Call screen | Live alert banner and AlertCard on caregiver home. Alert detail with Call and Acknowledge. Patient detail with timeline (TimelineItem) |

**Gate (P0):** items 1-10 run on two physical phones. If not, AI and APP-C stop voice and summary work on Saturday morning and help close the core loop.

### Sat 10 Oct — voice, memory, flags

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Recurring daily check-in on link, `startNow`, `ring` and `snooze`. `maxRequestSize`. `PatientsEndpoint.overview`. Tests 4-5 | Symptom store, repeat and severity rules, `safety_rules`. `MemoryService` (vector and recency), embeddings, memory write after retrieval. Hindi prompts reviewed by a native speaker. Test 6 | Active Voice Call screen: tap to talk, state labels, silence stop. Health tab timeline. Help tab (`tel:`, "Something feels wrong") | Caregiver triage list, "Check in now", Summary screen. "What Dhatri remembered" card on the latest check-in |

**Gate (P1 voice):** a Hindi round trip works on a phone and the second reply recalls earlier weakness from seeded data. If speech recognition is unreliable: the call screen offers four large Hindi answer buttons feeding the same pipeline (text instead of audio); keep text-to-speech for the questions.

### Sun 11 Oct — doctor view, freeze, deploy

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Production deploy. Config. `DemoEndpoint` seed and reset. Create the three demo accounts on Cloud | `InsightEndpoint.week` summary and rules. Seed data per `docs/DEMO.md`. Second turn of the call | Doctor shell: Dashboard and patient insight screens. Empty and error states on patient screens. Android APK on Cloud | Empty and error states on caregiver screens. Final script and shot list. README draft |

**Freeze at 20:00 IST.** After this, only bug fixes. P2 items start only if every P1 item is merged.

### Mon 12 Oct — record

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Server watch during filming. `DHATRI_GRACE_MINUTES=1`, `DHATRI_ENABLE_SEED=true`. Reset between takes | Patient's Hindi voice in the video | Patient phone operator | Directs, records both phones in one shot plus the doctor screen, edits under 2:00 |

### Tue 13 Oct — write and harden

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Fix what filming exposed. README tested on a clean machine. Turn `DHATRI_ENABLE_SEED` off, remove the demo token | Feedback log submitted as the feedback form | Fresh install of the APK on a second phone | Writeup including AI tool disclosure and the seeded-data disclosure. Upload the video (YouTube, public). Save the submission as a draft on BuilderBase |

### Wed 14 Oct — submit

Morning: everyone reviews the draft against §7. **The Representative submits by 18:00 IST.** APP-C publishes the build post the same day.

---

## 6. The video

Under 2:00. Scene list, spoken lines and the seed data are in `docs/DEMO.md`. Film both phones side by side in one shot for the alert scene. A cut there looks faked.

---

## 7. Submission checklist

- [ ] Working full-stack app with Serverpod as the backend, built during the hackathon
- [ ] Repository URL with source, assets and build instructions (shared with the three Serverpod emails if private)
- [ ] Text description of features and how it was built
- [ ] **AI tool use disclosed** (Cursor or other coding agent, Gemini, Sarvam, ChatGPT for planning)
- [ ] **Seeded history disclosed** (earlier check-ins and doses created by the seed script)
- [ ] Known limits stated: reminders reach the patient while the app is open; calls are in-app, not telephone
- [ ] Demo video under 2 minutes, public on YouTube or Vimeo, no copyrighted music
- [ ] Test access: APK link, server URL, patient, caregiver and doctor logins
- [ ] All materials in English
- [ ] Feedback form submitted (Most Valuable Feedback: $500 cash and $500 credits)
- [ ] Public post about the build, naming the hackathon (Best Hackathon Post: $500 credits)

---

## 8. Risks and cut order

| Risk | Signal | Response |
|---|---|---|
| Extraction unreliable | Fewer than 4 of 5 samples correct on 7 Oct | Review screen becomes manual entry with AI prefill |
| Streams drop on mobile data | Alerts arrive late | Reconnect plus reload. Film on Wi-Fi |
| Hindi recognition misreads | Wrong symptoms on 10 Oct | Four tap-to-answer Hindi options through the same pipeline |
| pgvector unavailable on Cloud | Spike S3 or the 9 Oct deploy fails | `MEMORY_MODE=recency`; say so honestly in the writeup |
| Gemini or Sarvam quota | 429 errors | Second key. Cached fixed audio |
| Cloud deploy problems | Deploy fails on 9 or 11 Oct | Keep trying from 9 Oct. Fallback: a VPS running the server and Postgres |
| Teammate unavailable for a day | Missed standup | Small PRs; another owner continues from `main` |
| Too much scope | A gate fails | Cut in this order |

**Cut order if time runs short** (stop at the first cut that restores the schedule):

1. P2 items.
2. Second turn of the care call (one turn is enough for the video).
3. Doctor Patients tab and Insights as separate tabs. Keep the single dashboard screen.
4. Caregiver triage list with several patients. Keep one patient.
5. Vector retrieval, using the recency fallback.
6. AI summary text, using the deterministic template.

Never cut: dose race safety, the human review screen, the live alert, the Hindi round trip, accessibility basics (48 dp targets, text scaling, labels beside colors).
