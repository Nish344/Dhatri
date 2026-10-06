# Dhatri — Overall Project Summary & Technical Direction

> **Branding:** The project name is written as **Dhatri** in documentation, code, UI labels, and general references. The logo/brand mark will use the stylized Sanskrit form **Dhātrī**. This is a visual branding choice; the canonical written project name remains **Dhatri**.

> **Purpose of this document:** This is the single source-of-truth summary for the Dhatri hackathon project. A new teammate or AI agent should be able to read this file and understand the product, decided feature scope, architecture direction, Serverpod usage, voice options, AI/memory strategy, and the intended video demonstration without needing the previous conversation.

---

## 1. Product

### Name

**Dhatri**

### Core idea

Dhatri turns a **photo of a prescription into an actionable care plan**.

It then helps patients—especially older patients who need ongoing support—stay on schedule, while keeping caregivers and doctors informed when something needs attention.

The product is more than a medication reminder:

> **Prescription → medication schedule → reminders → adherence monitoring → caregiver escalation → wellness calls → patient memory → longitudinal health insights.**

### One-line pitch

> **Turn a prescription into a living care plan—remind patients, detect missed doses, check how they are feeling, keep caregivers informed, and give doctors a continuous view of their patient's daily health.**

### Product positioning

Do **not** position Dhatri as only an “AI medicine reminder app.”

Position it as:

> **An AI-assisted remote-care companion for patients who need ongoing medication and wellness monitoring.**

The medication workflow is the entry point. The broader product is continuous care coordination and longitudinal patient context.

---

# 2. Target users

## Patient

Especially older patients who may:

- take multiple medications;
- forget scheduled doses;
- need periodic wellness check-ins;
- prefer voice/phone interactions over complicated apps;
- need support from a caregiver.

## Caregiver

Examples:

- adult children caring for parents;
- family members living in another city;
- home-care workers.

The caregiver needs:

- medication adherence visibility;
- immediate missed-dose alerts;
- ability to trigger/schedule calls;
- awareness of unusual wellness responses.

## Doctor / Healthcare professional

The doctor should not get a noisy stream of raw data.

Instead, Dhatri should provide:

- medication adherence;
- missed-dose history;
- wellness history;
- recurring concerns;
- concise patient trends;
- human-review alerts.

---

# 3. Core feature set we decided on

## A. Prescription Photo → Dhatri Schedule

The user uploads a photo of a prescription.

Dhatri extracts a structured draft such as:

```text
Medicine: Metformin 500 mg
Dhatri: 1 tablet
Frequency: Twice daily
Timing: Morning + evening
Duration: 30 days
Instruction: After meals
```

The extracted schedule must be shown for **human confirmation/correction** before activation.

### Important safety/design principle

Prescription extraction is AI-assisted, not blindly authoritative.

The UI should explicitly show:

> **AI extracted this schedule — review before activating.**

This protects against OCR/handwriting/abbreviation errors and makes the workflow realistic.

---

## B. Medication Scheduling

Once confirmed, Dhatri creates structured medication schedules.

Example:

```text
08:00 AM — Metformin 500 mg
08:00 PM — Metformin 500 mg
08:00 AM — Amlodipine 5 mg
```

Each scheduled dose becomes a trackable event.

Suggested status values:

```text
scheduled
reminded
taken
missed
skipped
unknown
```

---

## C. Patient Reminder

At the scheduled time:

> “It is time to take your evening medication.”

The patient can confirm:

> **Taken**

The confirmation is logged.

---

## D. Missed-Dhatri Detection + Caregiver Escalation

Example:

```text
8:00 PM
Dhatri reminder sent

8:15 PM
No confirmation

8:20 PM
Escalation threshold reached

→ Caregiver receives alert
```

Example caregiver alert:

> 🚨 Ramesh has not confirmed his 8 PM medication.

Actions:

- Call patient
- Dismiss / acknowledge
- Mark as handled

The goal is not to create alarm fatigue. Escalation should happen only after a configurable grace period or relevant rule.

---

## E. Scheduled Reminder Calls

Caregiver can schedule a call such as:

> “Call Mom at 8:30 PM.”

Or Dhatri can automatically initiate a reminder call after a missed dose.

For the hackathon, voice calls are a major differentiator.

---

## F. Wellness Calls

Dhatri should be able to make regular check-in calls that are **not necessarily medication-related**.

Examples:

> “How are you feeling today?”

> “Are you feeling unwell?”

> “Have you noticed anything unusual?”

> “Is there anything you would like your caregiver to know?”

The responses become part of the patient's health history.

This turns Dhatri from a reminder tool into a **continuous-care system**.

---

## G. Voice Interaction — Hindi First

The target voice experience is:

```text
Dhatri calls patient
        ↓
Hindi greeting
        ↓
Patient speaks Hindi
        ↓
Speech-to-text
        ↓
AI interprets response
        ↓
Relevant patient history retrieved
        ↓
AI generates next question
        ↓
Hindi TTS
        ↓
Patient responds again
```

Example:

> **Dhatri:** “नमस्ते रमेश जी। आज आप कैसा महसूस कर रहे हैं?”

Patient:

> “थोड़ा कमजोर महसूस कर रहा हूं।”

Dhatri should record the relevant wellness information rather than merely storing the raw transcript.

---

# 4. Dhatri Patient Memory — the AI context layer

This is an important decided feature, but it is **not the foundation of the MVP**.

The idea is:

> **Dhatri remembers what matters about the patient.**

A patient may say:

```text
Day 1:
“Feeling slightly tired.”

Day 3:
“Feeling weak.”

Day 5:
“Still feeling weak.”
```

On Day 5, Dhatri should be able to retrieve relevant previous observations and ask a more contextual question:

> “आपने कुछ दिन पहले भी कमजोरी महसूस होने की बात कही थी। क्या आज यह ज्यादा है?”

This is much more valuable than a generic chatbot.

---

## Structured data vs vector memory

Do NOT embed everything.

### Use normal Serverpod/PostgreSQL records for deterministic data

Examples:

```text
Patient
Caregiver
Doctor
Medication
Prescription
DhatriSchedule
DhatriEvent
Call
WellnessCheck
Symptom
Alert
```

Examples of SQL-style questions:

- Did the patient take the 8 PM dose?
- How many doses were missed this week?
- What medications are currently active?
- When is the next dose?
- How many wellness calls happened this month?

### Use semantic/vector memory for messy longitudinal text

Good candidates:

```text
Wellness conversation transcripts
Patient free-text notes
Caregiver notes
Doctor notes
AI-generated summaries
Previous symptom descriptions
Relevant conversation snippets
```

Examples of semantic questions:

- Has the patient described something similar before?
- What previous notes are relevant to today's complaint?
- Has weakness/fatigue been mentioned repeatedly?
- What related concerns appeared in recent conversations?

### Rule

> **SQL for facts. Vector retrieval for meaning/context.**

This avoids unnecessary RAG complexity.

---

# 5. Serverpod strategy

Serverpod should be the **central orchestration/backend layer**, not just a generic REST backend.

The product is a strong fit for Serverpod because multiple Dhatri requirements map directly to Serverpod features.

---

## Serverpod integration map

| Dhatri requirement | Serverpod feature | Use |
|---|---|---|
| Patient / caregiver / doctor accounts | Serverpod Auth | Authentication + identity |
| Patient/medication/dose records | Serverpod PostgreSQL models | Structured data |
| Prescription photo | Serverpod File Storage | Secure document upload |
| Scheduled dose actions | Future Calls | One-off scheduled jobs |
| Recurring wellness checks | Recurring Tasks / scheduled calls | Repeated jobs |
| Caregiver live alert | Streams / WebSockets | Real-time updates |
| Live doctor dashboard | Streams / WebSockets | Live state changes |
| Semantic patient memory | PostgreSQL + pgvector | Similarity retrieval |
| Role-based access logic | Auth + endpoint authorization | Patient/caregiver/doctor permissions |

### Serverpod scheduling

Use **Future Calls** for one-off future actions, such as:

```text
Reminder at 8 PM
Escalation at 8:20 PM
Call caregiver at scheduled time
Follow-up task after an event
```

Use recurring scheduling for:

```text
Daily wellness call
Weekly summary
Regular check-in
Periodic health analysis
```

Serverpod future calls are stored in the database, so they are not equivalent to an in-memory timer and are designed to survive server restarts.

### Serverpod Streams

Use Serverpod Streams/WebSockets for:

```text
Missed-dose alert
Dhatri state changes
Caregiver dashboard updates
Doctor dashboard updates
Live call/session events
```

This is especially useful in the recorded architecture/demo because it demonstrates that Serverpod is actively powering the care coordination layer.

### Serverpod File Storage

Prescription images should be stored through Serverpod storage.

Use private storage for patient documents.

Suggested pattern:

```text
prescriptions/{patientId}/{prescriptionId}.jpg
```

Keep the storage path/reference in the database instead of exposing a permanent public URL.

### Serverpod Auth

Suggested roles:

```text
PATIENT
CAREGIVER
DOCTOR
```

Every patient record should have clear ownership/authorization boundaries.

---

# 6. Serverpod Vector DB / pgvector decision

## Decision

**Use it, but as a secondary context layer — not as the core data store.**

Serverpod 4 supports vector fields backed by PostgreSQL `pgvector`.

Useful capabilities include:

- vector fields;
- similarity/distance search;
- vector indexes such as HNSW / IVFFLAT;
- normal database filtering alongside vector retrieval.

This means we can keep:

```text
Patient-specific records
+
semantic embedding
+
metadata
```

inside the same PostgreSQL/Serverpod ecosystem.

### Example

A memory record might conceptually contain:

```text
patientId
type = wellness_observation
text = "Patient reported weakness during evening call."
createdAt
embedding
```

When today's call says:

> “I'm feeling weak again.”

retrieve the most relevant memories for that patient and pass only the useful context to the AI.

### Do not build a giant generic RAG system.

Recommended flow:

```text
Current patient message
        +
Current structured patient state
        +
Top relevant semantic memories
        ↓
Context builder
        ↓
AI response
```

---

# 7. Voice architecture options

Voice is important because it changes Dhatri from an app reminder into a more accessible care system.

## Preferred cloud voice stack

### TTS: Sarvam Bulbul v3

This is the primary TTS candidate for the hackathon.

Current Sarvam documentation says Bulbul v3:

- supports Hindi (`hi-IN`);
- supports 11 languages total;
- has 30+ voices;
- supports streaming APIs;
- supports pace control;
- supports telephony-oriented audio codecs;
- is designed for Indian languages and accents.

Sarvam currently lists:

```text
Bulbul v3: ₹30 / 10,000 characters
```

and says each new user receives:

```text
₹100 free credits
```

These are current published API values and should be rechecked before production/competition submission because pricing can change.

### Why it is a strong choice

The voice should feel Indian and natural rather than like an English-first TTS system speaking Hindi.

It also supports code-mixed Indian speech patterns, which is useful for real conversations such as:

> “आज medicine ली?”

rather than forcing everything into formal Hindi.

---

## STT: Sarvam Saaras

For Hindi patient calls, use Sarvam Saaras for speech recognition.

Current Sarvam docs list Saaras as the Indian-language speech recognition family and support Hindi `hi-IN`.

Important: Sarvam's current documentation has examples/references to both Saaras v3 and newer Saaras v4 material, so the implementation should use the currently supported API version at build time rather than hardcoding an old model name.

---

# 8. Telephony option

## Exotel

Exotel is a strong candidate for real phone calls.

Their current AgentStream/Connect Voice AI documentation supports:

```text
Outbound phone call
        ↓
Answered call
        ↓
Bidirectional WebSocket
        ↓
Conversational AI bot
```

This is directly relevant to Dhatri because the bot can be the whole call experience for:

- reminders;
- wellness surveys;
- check-ins;
- caregiver-triggered calls.

Potential architecture:

```text
Serverpod Future Call
        ↓
Exotel outbound call
        ↓
Patient's phone
        ↕
Bidirectional audio
        ↕
Voice AI service
        ↓
STT → AI → TTS
```

For the hackathon this is optional but extremely compelling if available within the team's budget/access.

---

# 9. Local / open-source TTS alternatives

A provider abstraction should be used so Dhatri is not locked to one TTS vendor.

Recommended interface concept:

```text
VoiceEngine.synthesize(
    text,
    language,
    voice
)
```

Then implementations can be swapped.

---

## Option A — Piper

### Best use

**Fast/local/offline fallback.**

The current Piper project includes Hindi (`hi_IN`) voices.

It can run as a local HTTP server, making integration simple:

```text
Serverpod
   ↓ HTTP
Local Piper service
   ↓
Hindi WAV/audio
```

Advantages:

- local;
- fast;
- no API cost;
- easy service boundary;
- suitable as an offline fallback.

Important licensing note:

- current Piper engine project is GPLv3;
- voice models can have their own licenses/restrictions;
- review the specific Hindi voice model card before using it beyond the hackathon.

---

## Option B — AI4Bharat IndicF5

### Best use

**Higher-quality local/open TTS experiment.**

IndicF5 currently supports:

```text
Assamese
Bengali
Gujarati
Hindi
Kannada
Malayalam
Marathi
Odia
Punjabi
Tamil
Telugu
```

Its Hugging Face model card lists an MIT license.

Advantages:

- Indian-language focused;
- Hindi support;
- can run locally;
- potentially better naturalness for the final voice layer.

Downside:

- heavier/more involved deployment than a lightweight Piper setup.

### Recommended role

Prototype locally if time allows, but do not let TTS research delay the core Dhatri workflow.

---

# 10. Recommended voice strategy

Do **not** choose only one voice engine.

Use an abstraction:

```text
                     VoiceEngine
                         |
             +-----------+-----------+
             |                       |
         CloudVoice              LocalVoice
             |                       |
       Sarvam Bulbul v3            Piper
             |                       |
       primary/demo voice      offline fallback
             |
        optional later:
          IndicF5
```

Recommended priority:

1. **Sarvam Bulbul v3** — primary demo TTS.
2. **Sarvam Saaras** — Hindi STT.
3. **Exotel** — real telephone connection if feasible.
4. **Piper** — local/offline fallback.
5. **IndicF5** — higher-quality local experiment.

---

# 11. AI conversation architecture

Do not use a completely unconstrained LLM conversation.

Use a controlled pipeline:

```text
Patient speech
      ↓
Speech-to-text
      ↓
Structured extraction
      ↓
Patient memory retrieval
      ↓
Current medication / health context
      ↓
Context builder
      ↓
LLM
      ↓
Safety / response constraints
      ↓
Hindi response
      ↓
TTS
      ↓
Patient
```

The AI should extract useful structured information such as:

```text
mood
symptoms
severity
duration
medication_taken
new_concern
caregiver_note
needs_followup
```

The raw transcript can still be retained, subject to privacy/storage decisions.

---

# 12. AI should assist, not diagnose

Dhatri should **not** be presented as an AI doctor.

Avoid claims like:

> “The AI diagnoses disease.”

Prefer:

> “The AI identifies potentially concerning patterns and routes them to the appropriate human.”

Examples:

```text
Repeated missed medication
        ↓
Caregiver attention

Repeated wellness concern
        ↓
Review flag

Potentially concerning response
        ↓
Human escalation
```

This is safer and gives the product a much more credible healthcare position.

---

# 13. Patient Timeline

A central UI concept should be the **Patient Health Timeline**.

Example:

```text
DAY 1
✅ Morning medication
🙂 Feeling well

DAY 2
✅ Morning medication
😐 Mild fatigue

DAY 3
❌ Evening medication
⚠ Weakness reported

DAY 4
✅ Medication
⚠ Weakness continues

DAY 5
✅ Medication
⚠ Weakness reported again
```

This can feed the AI memory system and the doctor dashboard.

---

# 14. Doctor Dashboard

The doctor should receive a concise patient summary.

Example:

```text
RAMESH KUMAR
Age: 72

Medication adherence: 86%
Missed doses: 2 this week
Wellness check-ins: 7
Active concerns: 1

PATIENT INSIGHT
Repeated weakness reported
across 3 recent check-ins.

Medication adherence has
declined this week.

⚠ Review recommended
```

The doctor should also be able to inspect the timeline when needed.

The goal is:

> **raw patient interactions → useful clinical context**

not a huge data dump.

---

# 15. Video-submission strategy

## Important constraint

**There is no live demo. The project is being submitted as a recorded video.**

This changes the product/demo strategy.

The video should tell a complete patient story rather than relying on judges to click through the application.

---

## Recommended story

Use **one fictional elderly patient** and show a compressed journey across several days.

### Scene 1 — Prescription

```text
Upload prescription photo
        ↓
AI extracts medicines
        ↓
Caregiver confirms schedule
```

### Scene 2 — Medication reminder

```text
8:00 PM
Reminder sent
```

### Scene 3 — Missed dose

```text
Patient does not confirm
        ↓
Grace period expires
        ↓
Caregiver receives live alert
```

### Scene 4 — Caregiver initiates call

```text
Call Patient
        ↓
Hindi voice conversation
```

### Scene 5 — Wellness check

Patient says:

> “I'm feeling weak.”

Dhatri stores the relevant observation.

### Scene 6 — Time jump

Show:

```text
3 days later
```

Patient again says:

> “Still feeling weak.”

Dhatri retrieves previous relevant memory.

### Scene 7 — Context-aware follow-up

Dhatri responds differently because it remembers the previous observation.

This is the strongest demonstration of:

> **Patient Memory**

### Scene 8 — Doctor dashboard

Show the longitudinal summary:

```text
Repeated weakness
+
Missed doses
+
Medication adherence trend
=
Review recommended
```

### Scene 9 — Architecture

End with a compact architecture diagram:

```text
Flutter
   ↓
Serverpod
 ┌───────────────┐
 │ Auth          │
 │ PostgreSQL    │
 │ pgvector      │
 │ Future Calls  │
 │ Recurring     │
 │ Streams       │
 │ File Storage  │
 └───────────────┘
      ↓
AI / Voice
      ↓
Patient / Caregiver / Doctor
```

The video should show **why Serverpod is essential**, not merely mention that Serverpod was used.

---

# 16. MVP priority

The project should be implemented in this order.

## Must work

### P0

1. Prescription upload
2. Prescription extraction
3. Human confirmation of extracted schedule
4. Medication scheduling
5. Dhatri reminder
6. Dhatri confirmation
7. Missed-dose detection
8. Caregiver alert
9. Basic patient timeline

## Differentiator

### P1

10. Scheduled wellness calls
11. Hindi STT/TTS
12. Patient Memory using pgvector
13. Context-aware follow-up
14. Doctor dashboard

## Strong demo bonus

### P2

15. Real outbound phone call through Exotel
16. Fully conversational Hindi call
17. Caregiver-triggered calls
18. Automatic repeated-concern detection
19. Local TTS fallback
20. Automated patient summary generation

---

# 17. What NOT to overengineer

Avoid building these unless the core flow is complete:

- a generic multi-agent framework;
- a huge standalone vector database;
- complicated medical diagnosis;
- dozens of AI tools;
- a large EHR;
- a full hospital-management system;
- unnecessary microservices;
- complex analytics before basic patient history works.

The architecture should remain:

```text
One Serverpod backend
+
One database
+
One vector memory layer
+
Specialized AI services
+
Simple Flutter clients
```

---

# 18. Suggested high-level architecture

```text
                         ┌──────────────────────┐
                         │      FLUTTER         │
                         │ Patient / Caregiver  │
                         │ Doctor Dashboard     │
                         └──────────┬───────────┘
                                    │
                              Serverpod Client
                                    │
                   ┌────────────────▼────────────────┐
                   │            SERVERPOD            │
                   │                                 │
                   │ Auth                            │
                   │ Endpoints                       │
                   │ PostgreSQL                       │
                   │ Future Calls                    │
                   │ Recurring Tasks                 │
                   │ Streams / WebSockets            │
                   │ File Storage                    │
                   │ pgvector                        │
                   └───────┬──────────┬──────────────┘
                           │          │
                   ┌───────▼───┐  ┌──▼────────────────┐
                   │ AI Layer  │  │ Voice / Telephony │
                   │           │  │                   │
                   │ OCR       │  │ Sarvam STT        │
                   │ Extraction│  │ Sarvam TTS        │
                   │ Context   │  │ Exotel            │
                   │ Summary   │  │ Piper fallback    │
                   └───────────┘  └─────────┬─────────┘
                                            │
                                            ▼
                                      Patient phone
```

---

# 19. Core data model concept

Suggested Serverpod models:

```text
User / AuthUser
Patient
Caregiver
Doctor
PatientCaregiver
PatientDoctor

Prescription
PrescriptionFile

Medication
MedicationSchedule
DhatriEvent

Call
CallAttempt
WellnessCheck

Symptom
HealthObservation

PatientMemory
Alert
Notification

DoctorInsight
```

`PatientMemory` is the semantic-memory table.

Conceptually:

```text
PatientMemory
--------------
id
patientId
type
content
createdAt
embedding
metadata
```

Use metadata filters before or alongside similarity search where appropriate.

---

# 20. Key product principles

### Principle 1 — Human in the loop

AI extracts and suggests.

Humans confirm important actions.

### Principle 2 — Remember, don't diagnose

Dhatri should remember longitudinal context and surface concerns.

It should not pretend to replace clinicians.

### Principle 3 — Escalate intelligently

Not every missed action needs an emergency notification.

Use thresholds, grace periods, and repeated-pattern logic.

### Principle 4 — Voice should be accessible

Phone/Hindi interaction is valuable because elderly users should not have to navigate complex app interfaces for every interaction.

### Principle 5 — Serverpod should be visible in the architecture

The backend should genuinely use:

- Auth
- PostgreSQL models
- Future Calls
- Recurring Tasks
- Streams
- File Storage
- pgvector

rather than using Serverpod only nominally.

### Principle 6 — Build for the video

Because the judges will see a recorded submission, build a deterministic showcase flow that demonstrates a complete patient journey.

---

# 21. Recommended final stack

| Layer | Recommendation |
|---|---|
| App | Flutter |
| Backend | Serverpod 4 |
| Database | PostgreSQL |
| Semantic memory | pgvector through Serverpod |
| Authentication | Serverpod Auth |
| Scheduling | Serverpod Future Calls |
| Recurring jobs | Serverpod Recurring Tasks |
| Realtime | Serverpod Streams |
| File storage | Serverpod private storage |
| Prescription understanding | OCR + LLM / document extraction |
| Primary STT | Sarvam Saaras |
| Primary TTS | Sarvam Bulbul v3 |
| Telephony | Exotel |
| Local TTS fallback | Piper Hindi |
| Higher-quality local TTS experiment | AI4Bharat IndicF5 |
| LLM | Any suitable multilingual/conversational LLM; exact model can be selected during implementation |
| Frontend state | Keep simple; prioritize patient/caregiver/doctor workflows |

---

# 22. Final product story

The complete Dhatri story is:

```text
A caregiver uploads an elderly patient's prescription.

        ↓

Dhatri understands it and creates a schedule.

        ↓

Serverpod schedules the patient's reminders.

        ↓

The patient confirms doses.

        ↓

If a dose is missed,
the caregiver receives a real-time alert.

        ↓

Dhatri can call the patient.

        ↓

The patient speaks naturally in Hindi.

        ↓

Dhatri records how the patient is feeling.

        ↓

Patient Memory retrieves relevant previous observations.

        ↓

The next call is context-aware.

        ↓

Repeated concerns and adherence patterns
are summarized for the doctor.

        ↓

The doctor sees a longitudinal picture
instead of disconnected events.
```

### The central idea

> **Dhatri does not merely remind a patient to take medicine. It remembers, checks in, notices patterns, and connects the patient, caregiver, and doctor into one continuous care loop.**

---

# 23. Reference links / current technical verification

These links were checked while preparing this summary. Product APIs, prices, model versions, and licensing can change; verify again before final integration.

## Serverpod

- Future Calls: https://docs.serverpod.dev/concepts/scheduling/future-calls
- Scheduling overview: https://docs.serverpod.dev/concepts/scheduling/overview
- Vector fields / pgvector: https://docs.serverpod.dev/concepts/data-and-the-database/database/vector-and-geography-fields
- Vector indexes: https://docs.serverpod.dev/next/concepts/data-and-the-database/database/indexing
- Database tables/models: https://docs.serverpod.dev/concepts/data-and-the-database/database/tables
- Streaming / WebSockets: https://docs.serverpod.dev/concepts/endpoints-and-apis/streaming
- File uploads/storage: https://docs.serverpod.dev/concepts/endpoints-and-apis/file-uploads
- Authentication: https://docs.serverpod.dev/concepts/authentication/setup

## Sarvam

- Bulbul v3: https://docs.sarvam.ai/api/getting-started/models/bulbul
- Current pricing: https://docs.sarvam.ai/api/getting-started/pricing
- Building for Indian languages: https://docs.sarvam.ai/api/getting-started/building-for-india
- Speech/TTS overview: https://docs.sarvam.ai/api/getting-started/welcome

## Exotel

- Connect Voice AI: https://developer.exotel.com/docs/agentstream/connect-voice-ai

## Local/open-source voice

- Piper voices: https://github.com/OHF-Voice/piper1-gpl/blob/main/docs/VOICES.md
- Piper HTTP API: https://github.com/OHF-Voice/piper1-gpl/blob/main/docs/API_HTTP.md
- Piper project: https://github.com/OHF-Voice/piper1-gpl
- AI4Bharat IndicF5: https://huggingface.co/ai4bharat/IndicF5

---

## Status

**Product direction:** Frozen at a high level.

**Primary demo narrative:** Frozen.

**Vector memory:** Use as a secondary context layer.

**Primary voice candidate:** Sarvam Bulbul v3 + Saaras.

**Local voice fallback:** Piper.

**Optional higher-quality local voice:** IndicF5.

**Telephony candidate:** Exotel.

**Backend:** Serverpod-centric.

**Submission format:** Recorded video; design the product/demo around a controlled, deterministic story rather than assuming a live judge interaction.
