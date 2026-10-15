# Dhātrī — An AI Care Companion for Indian Elder Care

## The problem we set out to solve

In India, millions of elderly patients manage multiple chronic medications at home while their adult children live in other cities. A handwritten prescription becomes a vague daily routine. When a dose is missed at 8 PM, nobody knows until the next family call — sometimes days later. When a parent says “I feel weak,” it disappears into conversation instead of becoming clinical context for the doctor.

Generic medicine-reminder apps fail this audience for three reasons. They assume English UI literacy, while many elders navigate better by voice in Hindi than by tapping dense screens. They stop at the reminder — they do not escalate to a caregiver in real time, or connect adherence to wellness. And they forget: each check-in is a blank slate, so repeated weakness never becomes a pattern a doctor can review.

We built Dhātrī (Sanskrit: *the one who sustains*) to close that loop: turn a prescription into a living care plan, watch adherence, check in by voice in Hindi, remember what mattered, and keep caregiver and doctor in sync.

## What Dhātrī does

Dhātrī is a multi-role Flutter app backed by a Serverpod backend. Patients get a large, high-contrast UI with a clear next-dose card, one-tap “Taken,” and in-app Hindi care calls. Caregivers upload a prescription photo, review the AI-extracted schedule before it goes live, receive live missed-dose alerts, triage concerns, and can trigger a check-in. Doctors get a read-only dashboard with adherence, repeated symptoms, and a factual AI weekly insight.

The end-to-end care loop is: prescription photo → AI draft schedule (Gemini) with human confirm → dose events scheduled on Serverpod → reminder → Taken or Missed → live caregiver alert over a WebSocket stream → Hindi voice care call (Sarvam STT/TTS) → Patient Memory (pgvector) recalls earlier concerns → the doctor sees adherence, repeated weakness, and insight.

AI assists; humans stay in control. Prescriptions are never activated without caregiver review. Dhātrī does not diagnose — it notices patterns and routes them to people.

## Why Serverpod was the right backend

We did not use Serverpod as a thin REST layer. The product map fits Serverpod’s built-ins almost one-to-one, which let us ship a complete care system in days instead of wiring microservices.

Patient, caregiver, and doctor accounts use Serverpod Auth (email + JWT, with role on Profile). Medicines, doses, alerts, and wellness live as PostgreSQL models from `.spy.yaml`, with a typed generated client. Prescription images go into private file storage. Remind-at-8:00 and escalate-after-grace are Future Calls that survive restarts; daily care calls per patient are recurring tasks. When a dose is missed, the caregiver sees it live through Streams / WebSockets — a CareUpdate on the patient channel. “You mentioned weakness before…” comes from pgvector on PatientMemory (HNSW, cosine). Code generation gave us one typed Flutter client for all three roles.

The rule every feature follows: mutate Postgres, then post a CareUpdate. That single bus is how a missed dose lights up the caregiver phone and how the patient phone rings for a care call — without a separate notification microservice. Typed models and migrations kept three roles, scheduling, realtime, and vector memory in one deployable server, which was decisive for a hackathon-scoped but production-shaped build.

## Why Flutter on the front

One Flutter app, three shells chosen by Profile.role. That mattered for elder accessibility — large type, high contrast, Hindi copy, generous tap targets, labels beside color. It also mattered for dual-phone demos: patient and caregiver on real devices, same codebase, same Serverpod client. The voice UX is an active call screen with waveform, clear “Dhatri speaking / your turn / listening” states, and Hindi quick-answer chips if speech recognition is noisy. The WebSocket care stream with reconnect banners means the caregiver dashboard updates the moment a dose is missed. Flutter plus Serverpod’s generated client meant UI work stayed on workflows, not hand-written HTTP DTOs.

## Regional language voice — built for Hindi first

Elders in our target setting speak Hindi, often code-mixed with English medicine names (“आज medicine ली?”). English-first voice stacks sound foreign and mishear Indian accents. We chose an India-focused voice stack and wired it behind a thin VoiceEngine (transcribe / speak) so vendors stay swappable.

Speech-to-text uses Sarvam Saaras (saaras:v3) to turn patient Hindi audio into a transcript with language code hi-IN. Text-to-speech uses Sarvam Bulbul (bulbul:v3) with speaker priya so replies sound natural in Hindi. Google Gemini handles conversation and extraction — interpreting the check-in, pulling symptoms into structured JSON, and writing the Hindi reply — and also provides embeddings so patient memories can be stored and retrieved in pgvector. Prescription understanding uses Gemini vision: photo to draft medication schedule. On-device Flutter TTS and speech_to_text act as a soft fallback if Sarvam is unavailable, with Hindi answer chips if STT is unreliable.

The care call flow is: patient speaks Hindi → Sarvam Saaras (STT) → Gemini plus Patient Memory from pgvector → Hindi reply text → Sarvam Bulbul v3 (TTS) → patient hears Dhātrī speak.

Example: Dhātrī greets “नमस्ते रमेश जी। आज आप कैसा महसूस कर रहे हैं?” The patient answers “थोड़ा कमजोर महसूस कर रहा हूं।” With memory, Dhātrī recalls earlier weakness and asks whether it is worse today — then the caregiver and doctor see the pattern.

We evaluated Piper and AI4Bharat IndicF5 as local/open TTS options for offline fallback; the shipped demo path is Sarvam for Indian-language quality under hackathon constraints, with device TTS as a soft fallback in the Flutter client.

## What “complete and functional” means in this submission

Working end-to-end: auth and role-based shells for patient, caregiver, and doctor; prescription upload → AI extract → human confirm → dose schedule; reminders, Taken confirmation, and missed-dose escalation; live caregiver alerts over Serverpod streams; in-app Hindi care call (STT → AI → TTS) with memory-aware follow-up; symptom and repeat rules; doctor insight dashboard; and a seeded demo narrative (Ramesh Kumar) for a deterministic video story.

Honest scope notes: care calls are in-app (not PSTN/Exotel); patient reminders assume the app is reachable (no FCM in this build). Those were deliberate cuts so the core Serverpod-orchestrated loop stayed solid.

## One-line summary

Dhātrī turns a prescription into continuous elder care — Flutter for accessible multi-role UX, Serverpod for auth, scheduling, realtime alerts, and patient memory, and Sarvam’s Hindi STT/TTS so the people who need it most can speak naturally in their own language.
