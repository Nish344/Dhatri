# Dhatri — Team Plan

Four people, eight days. Technical details are in `ARCHITECTURE.md`.

**Deadline:** 14 October 2026, 23:59 CEST, which is **15 October, 03:29 IST**. We submit by **14 October, 18:00 IST** and do not use the last night.

---

## 1. What we are building

One sentence: a caregiver photographs a prescription, Dhatri turns it into reminders, the caregiver's phone alerts live when a dose is missed, and a Hindi voice check-in flags symptoms that keep coming back.

### Must work (the video depends on it)

1. Caregiver uploads a prescription photo.
2. AI extracts medicines, and the caregiver reviews and confirms.
3. Dose events are scheduled. The patient gets a reminder and taps Taken.
4. An unanswered reminder becomes a missed dose, and the caregiver's phone alerts live.
5. Caregiver taps "Check in now". The patient hears a Hindi question, answers by voice, and hears a Hindi reply.
6. A symptom reported 3 times in 7 days shows as a flag on the caregiver's weekly summary.

### Not building

Doctor role, real phone calls, push notifications, vector memory, local voice engines, offline sync, payments, chat.

### How we are judged

| Criterion | Weight | What it means for us |
|---|---|---|
| Does it work | 30% | The six steps above run on two real phones with nothing faked. Also the tie-breaker |
| Use of the Serverpod stack | 25% | Future calls, a recurring task, streams, file storage, auth, and serializable transactions all do real work |
| Craft and technical creativity | 25% | Race-safe dose states, jobs that are safe to repeat, a clean review screen |
| Usefulness | 20% | A named user (an elderly parent and the adult child in another city) with a real problem |

Judges may score from the video and writeup alone and stop watching at 2 minutes.

---

## 2. Team and ownership

Each track has one owner who decides and merges for that area. Fill in names.

| Track | Owner | Owns |
|---|---|---|
| **BE: Backend core** | _name_ | Project scaffold, auth, all models and migrations, `access.dart`, profile, prescription upload and `confirm`, dose scheduling, future calls, `dose_rules.dart`, care stream, integration tests, Serverpod Cloud deploy |
| **AI: AI and voice** | _name_ | `gemini.dart`, `sarvam.dart`, prompts and schemas, `extract` job body, check-in endpoint, `symptom_rules.dart`, summary endpoint, Hindi copy, sample prescriptions |
| **APP-P: Patient app and app shell** | _name_ | Flutter project setup, sign in, onboarding, `care_stream.dart`, patient home, full-screen reminder, check-in screen (record and play audio) |
| **APP-C: Caregiver app and story** | _name_ | Caregiver home, upload flow, prescription review, summary screen, video script and recording, README, writeup, public build post |

Pairing when blocked: BE pairs with APP-P on streams and auth; AI pairs with APP-C on the review screen and summary.

### Shared rule

The models and endpoint signatures in `ARCHITECTURE.md` sections 4 and 5 are the contract. Changing one needs a message in the team chat first, because three people code against it.

---

## 3. Day-zero setup (6 October, evening)

Nothing is installed yet. Do this together.

1. **Everyone:** register on the BuilderBase event page and join one team (maximum 4). Choose a Representative who submits.
2. **Everyone:** install Flutter, or Serverpod App Studio, which bundles Flutter, Dart and the Serverpod tools.
3. **BE:** create the GitHub repo. The hackathon site can create a private repo under Serverpod's GitHub organisation. If we use our own private repo, share it with viktor@serverpod.dev, alexander@serverpod.dev and isak@serverpod.dev before submitting.
4. **BE:** `serverpod create dhatri`, commit, push. Add `config/passwords.yaml` to `.gitignore`.
5. **AI:** create Gemini and Sarvam API keys. Share them privately, never in the repo.
6. **Everyone:** clone, run `serverpod start`, and see the template app talk to the server.

---

## 4. Working agreement

- `main` always runs. Work on branches named `be/...`, `ai/...`, `app-p/...`, `app-c/...`.
- Small pull requests, merged the same day. One other person reviews.
- **Only BE creates migrations.** Others propose model changes in chat. Two people creating migrations at once is the most likely merge conflict in a Serverpod repo.
- After any model or endpoint change, run code generation and commit the regenerated `dhatri_client` in the same PR.
- `passwords.yaml` is never committed.
- 15-minute standup at 10:00 IST: yesterday, today, blocked.
- Keep a shared feedback log of every Serverpod bug, confusing doc and missing feature we hit. It becomes the Most Valuable Feedback entry.

---

## 5. Schedule

Gates are checked at the evening standup. A failed gate changes the plan the next morning.

### 6 Oct (Tue) — scaffold

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Day-zero setup. Email sign-in working. All models from `ARCHITECTURE.md` §4, first migration | API keys. Plain Dart script calling Gemini with a prescription photo and printing JSON | Flutter app runs against local server. Sign-in screen | Collect 5 printed prescriptions (2 simple, 2 multi-drug, 1 hard). Draft the video script |

### 7 Oct (Wed) — contract in place

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| **By 13:00:** every endpoint in §5 exists with real signatures and placeholder bodies, so the app team codes against the generated client. Then: `requireAccess`, profile and linking, upload ticket and `submit` | Extraction schema and prompt tuned on the 5 samples. Sarvam text-to-speech script producing a Hindi WAV | Onboarding (role, link code). Routing by role | Caregiver home layout. Upload flow with `image_picker` and `FileUploader` |

**Gate:** extraction is correct on at least 4 of 5 samples. If not, the review screen opens with empty rows the caregiver fills in, and extraction becomes a prefill. The rest of the flow is unchanged.

### 8 Oct (Thu) — schedule and escalation

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| `confirm()` creates dose events. `remind` and `escalate` future calls. `dose_rules.transition`. Integration tests 1 and 2 | `extract` future call body wired into `PrescriptionFutureCall`. Sarvam speech-to-text tested with recorded Hindi | Patient home: today's doses, Taken button, `markTaken` | Prescription review screen: banner, editable rows, confirm |

### 9 Oct (Fri) — live on two phones

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Care stream endpoint and `postMessage` on every state change. Help APP-P with the subscription | Check-in endpoint: `question` and `answer` pipeline | `care_stream.dart` with reconnect. Full-screen reminder on `reminded` | Live alert banner on caregiver home. Acknowledge |

**Gate:** steps 1 to 4 of "Must work" run on two physical phones. If not, AI and APP-C stop voice and summary work tomorrow and everyone fixes the core loop.

### 10 Oct (Sat) — voice and summary

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Recurring daily check-in on link, `startNow`. `maxRequestSize` raised. Integration test 3 with AI | `symptom_rules.dart`. `SummaryEndpoint.week`. Hindi prompts reviewed by a native speaker | Check-in screen: play question, hold to record (stop at 25 s), play reply | Summary screen. "Check in now" button |

**Gate:** a Hindi check-in round trip works on a phone. If not, the check-in falls back to the patient tapping one of four answers in Hindi, still sent through the same symptom pipeline. Keep text-to-speech for the question.

### 11 Oct (Sun) — feature freeze and deploy

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Deploy to Serverpod Cloud with hackathon credits. Production config. Seed demo accounts | Seed script for earlier check-ins and doses (disclosed in the writeup) | Android APK pointed at Cloud. Error and empty states on patient screens | Error and empty states on caregiver screens. Final video script and shot list |

**Freeze at 20:00 IST.** After this, only bug fixes.

### 12 Oct (Mon) — record

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Server watch during filming, `DHATRI_GRACE_MINUTES=1` | Voice for the patient in the video | Patient phone operator | Directs, records both screens, edits under 2:00 |

### 13 Oct (Tue) — write and harden

| BE | AI | APP-P | APP-C |
|---|---|---|---|
| Fix anything filming exposed. README run instructions tested on a clean machine | Submit the feedback log as the feedback form | Fresh install test of the APK on a second phone | Writeup, including AI tool disclosure. Upload video to YouTube (public). Save the submission as a draft on BuilderBase |

### 14 Oct (Wed) — submit

Morning: everyone reviews the draft submission against the checklist below. **Representative submits by 18:00 IST.** APP-C publishes the build post the same day.

---

## 6. The video (under 2:00)

| Time | Scene | Shows |
|---|---|---|
| 0:00–0:10 | Ramesh, 72, lives alone. His daughter lives in another city | The user and the problem |
| 0:10–0:35 | Daughter photographs the prescription. AI draft appears, she fixes one time, confirms | File storage, background job, human in the loop |
| 0:35–1:00 | 20:00 reminder on Ramesh's phone. Nobody taps. One minute later her phone alerts | Future calls, live stream across two phones |
| 1:00–1:35 | She taps "Check in now". Ramesh hears Hindi, says "????? ????? ????? ?? ??? ???" ("I'm feeling a bit weak"). Dhatri replies, recalling earlier weakness | Voice pipeline, memory from SQL |
| 1:35–1:50 | Weekly summary: weakness reported 3 times, flagged; 2 missed doses | Repeat rule, adherence |
| 1:50–2:00 | Architecture: Serverpod at the centre | Stack use |

Film both phones side by side in one shot for the alert scene. A cut there looks faked.

---

## 7. Submission checklist

From the official rules:

- [ ] Working full-stack app with Serverpod as the backend, built during the hackathon
- [ ] Repository URL with all source, assets and build instructions (shared with the three Serverpod emails if private)
- [ ] Text description of features and how it was built
- [ ] **AI tool use disclosed** in the description (Cursor, Gemini, Sarvam)
- [ ] Build and run instructions
- [ ] Demo video under 2 minutes, public on YouTube or Vimeo, no copyrighted music
- [ ] Test access: APK link, server URL, demo patient and caregiver logins
- [ ] All materials in English
- [ ] Feedback form submitted (Most Valuable Feedback: $500 cash and $500 in credits)
- [ ] Public post about the build, naming the hackathon (Best Hackathon Post: $500 in credits)

---

## 8. Risks

| Risk | Signal | Response |
|---|---|---|
| Extraction unreliable | Fewer than 4 of 5 samples correct on 7 Oct | Review screen becomes manual entry with AI prefill |
| Streams drop on mobile data | Alerts arrive late in testing | Reconnect plus reload `today()`. Film on Wi-Fi |
| Hindi speech recognition misreads | Wrong symptoms on 10 Oct | Four tap-to-answer Hindi options through the same pipeline |
| Sarvam or Gemini quota runs out | 429 errors | Second key ready. Cache the fixed greeting audio |
| Serverpod Cloud deploy problems | Deploy fails on 11 Oct | Start deploy attempts on 9 Oct. Fallback: a VPS running the server and Postgres |
| A teammate is unavailable for a day | Missed standup | Each track's PRs are small, so another owner can continue from `main` |

### Stretch, only if the 10 Oct gate passed and before the 11 Oct freeze

1. Caregiver can play back the patient's recorded answer.
2. Read-only doctor view of the weekly summary in Flutter web.

Nothing else gets added.
