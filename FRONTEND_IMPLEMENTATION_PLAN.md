# Dhatri Frontend Application — Detailed Implementation Plan

> **Platform:** Flutter (Mobile & Tablet)  
> **Target Roles:** Patient (Elderly-first), Caregiver (Triage & Actions), Doctor (Clinical Insights)  
> **Architecture Pattern:** Clean UI Layer + Unified Mock Repository & Reactive Stream Engine  
> **Design North Star:** Calm, accessible, trustworthy, high-contrast, linear navigation, zero color-alone signals.

---

## Executive Summary & Scope

This implementation plan focuses exclusively on building the **complete Flutter frontend application** (`dhatri_flutter`) with an integrated, high-fidelity **Mock Data & Real-Time Simulation Engine**. 

The frontend implements 100% of the UI/UX specifications from `Dhatri_UI_UX_Design_Guide.md` and aligns its data contracts with `ARCHITECTURE.md`. By utilizing a clean repository pattern and a reactive simulated Care Stream, the frontend functions end-to-end immediately—including prescription review, medication reminders, missed-dose escalation alerts, Hindi voice check-in calls with Patient Memory retrieval, and longitudinal clinical dashboards—without requiring a live backend or paid cloud API keys during local development and video recording.

---

## 1. Architecture & Directory Structure

```text
dhatri_flutter/
├── lib/
│   ├── main.dart                          # App entry point, global providers, theme config
│   │
│   ├── core/                              # Core design system & utilities
│   │   ├── theme/
│   │   │   ├── app_colors.dart            # High-contrast accessible medical palette
│   │   │   ├── app_typography.dart        # Elderly-scaled legible typography (20sp+ base)
│   │   │   └── app_theme.dart             # Material 3 theme definitions (Light & Warm)
│   │   ├── constants/
│   │   │   └── copy_hindi.dart            # Authentic Devanagari voice scripts & strings
│   │   └── utils/
│   │       ├── date_formatter.dart        # IST relative formatting ("Today, 8:00 PM")
│   │       └── accessibility_utils.dart   # Touch target enforcement & semantic helpers
│   │
│   ├── models/                            # Data contracts strictly matching ARCHITECTURE.md §4
│   │   ├── profile.dart                   # Patient, Caregiver, Doctor profiles & link codes
│   │   ├── prescription.dart              # Prescriptions, draft schedules & uncertainty flags
│   │   ├── medication.dart                # Active medications, strengths, dosages & timings
│   │   ├── dose_event.dart                # Scheduled, Reminded, Taken, Missed states
│   │   ├── wellness_check.dart            # In-app care call turns, transcript & moods
│   │   ├── symptom_report.dart            # Symptom types, severities (1-5) & timestamps
│   │   ├── patient_memory.dart            # Longitudinal vector/recency memory items
│   │   ├── alert.dart                     # Escalated missed doses & severe symptom alerts
│   │   ├── care_update.dart               # Real-time WebSocket event wrapper
│   │   ├── timeline_item.dart             # Multi-day unified health journey items
│   │   └── patient_insight.dart           # Computed clinical summary & adherence statistics
│   │
│   ├── mock_engine/                       # Standalone offline mock data & simulation
│   │   ├── mock_database.dart             # Seeded 7-day realistic journey for Ramesh Kumar
│   │   ├── mock_care_stream.dart          # Reactive StreamController simulating Serverpod care_bus
│   │   ├── mock_voice_engine.dart         # Scripted 2-turn Hindi dialogue & memory retrieval
│   │   └── mock_prescription_samples.dart# Sample prescription image assets & draft JSONs
│   │
│   ├── repositories/                      # Clean contract interface
│   │   ├── dhatri_repository.dart         # Abstract interface matching endpoints
│   │   └── mock_dhatri_repository.dart    # High-fidelity implementation with event triggers
│   │
│   ├── state/                             # Reactive State Management (ChangeNotifier / ValueNotifier)
│   │   ├── auth_state.dart                # Current active role (Patient / Caregiver / Doctor)
│   │   ├── care_state.dart                # Live patient care state, doses, alerts & stream listener
│   │   └── voice_call_state.dart          # Active call lifecycle, speech states & turns
│   │
│   ├── ui/
│   │   ├── components/                    # Standardized reusable design system components
│   │   │   ├── dhatri_buttons.dart        # Primary (56-64dp), Secondary, Destructive, Call (72dp)
│   │   │   ├── dhatri_status_chip.dart    # Triple-signal chip (Icon + Label + Accessible Color)
│   │   │   ├── dhatri_medication_card.dart# Dominant Next Dose card & Checklist item
│   │   │   ├── dhatri_alert_card.dart     # Caregiver triage alert with inline "Call" action
│   │   │   ├── dhatri_patient_card.dart   # Caregiver patient overview item
│   │   │   ├── dhatri_timeline_item.dart  # Multi-day chronological card
│   │   │   ├── dhatri_memory_card.dart    # "What Dhatri Remembered" context preview
│   │   │   ├── dhatri_audio_waveform.dart # Pulsing audio visualizer for speaking/listening
│   │   │   ├── dhatri_connection_banner.dart # "Updated just now" / "Live" indicator
│   │   │   ├── dhatri_empty_state.dart    # Meaningful reassuring empty states
│   │   │   └── dhatri_demo_toolbar.dart   # Interactive demo floater for video filming
│   │   │
│   │   └── screens/
│   │       ├── patient/                   # Low Density — Confidence & 1 Action at a time
│   │       │   ├── patient_shell.dart     # Bottom Nav: Today, Medicines, Health, Help
│   │       │   ├── patient_home_screen.dart # Dominant Next Dose card & routine summary
│   │       │   ├── incoming_call_screen.dart# Phone-style incoming Dhatri call UI
│   │       │   ├── active_call_screen.dart # Hindi voice call with explicit states & wave
│   │       │   ├── patient_medicines_screen.dart # Chronological medication checklist
│   │       │   ├── patient_health_screen.dart # 7-day longitudinal patient timeline
│   │       │   └── patient_help_screen.dart# Emergency 112, Call Caregiver, Need Help trigger
│   │       │
│   │       ├── caregiver/                 # Medium Density — Operational Triage & Rapid Action
│   │       │   ├── caregiver_shell.dart   # Bottom Nav: Home, Patients, Alerts, Upload
│   │       │   ├── caregiver_home_screen.dart # Triage counter ("8 patients · 2 need attention")
│   │       │   ├── alert_detail_screen.dart# Escalation detail, patient history & instant call
│   │       │   ├── patient_detail_screen.dart# Ramesh's profile, memories & "Check-in now"
│   │       │   ├── prescription_upload_screen.dart # Camera/picker & animated OCR reader
│   │       │   └── prescription_review_screen.dart # Human-in-the-loop schedule review & edit
│   │       │
│   │       └── doctor/                    # High Density — Context, Trends & Review Flags
│   │           ├── doctor_shell.dart      # Navigation shell & patient selector
│   │           ├── doctor_dashboard_screen.dart # Adherence stats & AI Clinical Summary
│   │           └── doctor_patient_insight_screen.dart # Multi-day trends & symptom counts
```

---

## 2. Phase-by-Phase Step-by-Step Implementation

### Phase 1: Foundation, Design System & Accessibility Kit
*Target Goal: Establish the visual and ergonomic foundation ensuring all elderly-accessibility standards are baked in from line one.*

1. **Color Palette (`app_colors.dart`)**:
   - `primaryTeal` (`#0A686D`): Calming, authoritative clinical tone.
   - `primaryLight` (`#E6F4F4`): Soft card background for primary highlights.
   - `surfaceLight` (`#FFFFFF`): Clean card surfaces.
   - `backgroundWarm` (`#F7F9F9`): Warm off-white reducing glare for older eyes.
   - `textDark` (`#111827`): Contrast ratio > 7:1 against light surfaces.
   - `textSubtle` (`#4B5563`): High-legibility neutral supporting text (never faint gray).
   - `statusSuccess` (`#15803D`) + `statusSuccessBg` (`#DCFCE7`): `✓ TAKEN`.
   - `statusWarning` (`#B45309`) + `statusWarningBg` (`#FEF3C7`): `⚠ ATTENTION`.
   - `statusError` (`#B91C1C`) + `statusErrorBg` (`#FEE2E2`): `❌ MISSED` / `🚨 URGENT`.
   - `statusInfo` (`#1D4ED8`) + `statusInfoBg` (`#DBEAFE`): `○ UPCOMING`.

2. **Elderly-First Typography & Scaling (`app_typography.dart`)**:
   - Base sizes: Page Title (30sp), Section Title (22sp), Primary Action (20sp), Body (18sp), Supporting (16sp).
   - Ensure layouts wrap and use `TextScaler` safely with flexible containers—never setting fixed-height containers with `overflow: TextOverflow.clip` on critical instructions.

3. **Accessibility Standard Validation (`accessibility_utils.dart`)**:
   - Minimum tap target constraint: `48×48 dp`.
   - Primary action buttons: `58–64 dp` height.
   - Major call action: `68–72 dp` height.
   - Color Independence: Every status widget strictly pairs **Color + Icon + Text Label**.

---

### Phase 2: Domain Data Models & Realistic Mock Engine
*Target Goal: Complete parity with `ARCHITECTURE.md` §4 and generate a rich, 7-day realistic clinical dataset.*

1. **Domain Models**:
   - `Profile`: ID, name, role (`Role.patient`, `Role.caregiver`, `Role.doctor`), age (72), phone (`+91 98765 43210`), linkCode (`482910`).
   - `Medication`: Metformin 500 mg (After meals, 08:00 & 20:00), Amlodipine 5 mg (Morning, 08:00), Atorvastatin 20 mg (Night, 22:00).
   - `DoseEvent`: Today's doses with states (`scheduled`, `reminded`, `taken`, `missed`) and timestamps.
   - `WellnessCheck`: Check-in record containing turns, Hindi replies, mood (`good`, `okay`, `low`), English summaries, and retrieved memories.
   - `SymptomReport`: Symptom name (e.g. `weakness`), severity (1-5), and timestamp.
   - `PatientMemory`: Semantic memory snippets with timestamps.
   - `Alert`: AlertKind (`missedDose`, `repeatedSymptom`, `severeSymptom`, `patientHelp`), priority (`attention`, `important`, `high`), acknowledged state.
   - `PatientInsight`: Adherence % (86% down from 92%), missed dose count (2), symptom occurrences (Weakness 3x in 7 days), review recommended flag (`true`), and Gemini AI summary.

2. **Mock Data Generator (`mock_database.dart`)**:
   - Pre-seeds **Ramesh Kumar (72)** with a 7-day medical narrative matching `docs/DEMO.md`:
     - **Day -5**: Check-in: "Mild fatigue reported". Dose adherence: 100%.
     - **Day -3**: Evening dose missed. Check-in: "Weakness reported (severity 2)".
     - **Day -1**: Check-in: "Weakness continues (severity 3)".
     - **Today**:
       - 08:00 AM: Metformin 500 mg (`taken`).
       - 08:00 AM: Amlodipine 5 mg (`taken`).
       - 08:00 PM: Metformin 500 mg (`reminded` -> ready to be taken or escalated).

3. **Reactive Care Stream Simulation (`mock_care_stream.dart`)**:
   - A centralized `StreamController<CareUpdate>.broadcast()` allowing real-time simulated push events across the app.
   - Allows instant triggering of:
     - Missed Dose Escalation: shifts 8:00 PM dose to `missed` and pushes a live `Alert` to the caregiver.
     - Incoming Wellness Call: pushes an active `WellnessCheck` to the patient phone.
     - Taken Dose confirmation: reflects immediately across caregiver and patient screens.

---

### Phase 3: Standardized Component Library (12 Core Widgets)
*Target Goal: Build modular, accessible components in `lib/ui/components/` as mandated by Section 17 of the Design Guide.*

1. **`DhatriPrimaryButton`**: Minimum 58dp height, large 20sp bold text, rounded corners (16dp), tactile feedback, high contrast background.
2. **`DhatriSecondaryButton`**: Accessible outlined button with 48dp+ tap area.
3. **`DhatriStatusChip`**: Semantic chip combining icon (`Check`, `AlertTriangle`, `Clock`, `XCircle`), text label (`TAKEN`, `MISSED`, `UPCOMING`), and WCAG AA background/foreground contrast.
4. **`DhatriMedicationCard`**: Dominant card for Next Dose with giant pill icon, name, strength, instructions, and inline "✓ TAKE NOW" button.
5. **`DhatriAlertCard`**: Triage card with urgent amber/red border, descriptive alert text ("Ramesh has not confirmed his 8:00 PM medication"), and instant action button `[ CALL PATIENT ]`.
6. **`DhatriPatientCard`**: Clean patient list card for caregiver showing patient name, age, status chip, and next dose time.
7. **`DhatriTimelineItem`**: Chronological card with vertical connector line, tone badges (Good / Warning / Missed), and clear timestamp.
8. **`DhatriMemoryCard`**: Distinctive warm card titled *"What Dhatri remembered"* highlighting context recall from earlier calls.
9. **`DhatriAudioWaveform`**: Animated pulsating wave showing vocal activity when Dhatri or the patient speaks.
10. **`DhatriConnectionBanner`**: Subtle persistent bar showing `"Updated just now"` or `"Simulated Live Stream"`.
11. **`DhatriEmptyState`**: Friendly, reassuring empty state illustration and action button.
12. **`DhatriDemoToolbar`**: Floating bottom control sheet for live video recording: lets the presenter switch roles instantly, trigger a missed dose, trigger a call, or reset data in one tap.

---

### Phase 4: Patient Experience (6 Screens)
*UX Focus: Zero cognitive overload. One single dominant question answered: "What do I need to do right now?"*

1. **Screen 1 — Patient Home / Today's Care (`patient_home_screen.dart`)**:
   - Header: *"Good evening, Ramesh"* + date in friendly plain Hindi/English format.
   - **Dominant Hero Card**: *"YOUR NEXT MEDICINE"*:
     - 💊 Metformin 500 mg — 8:00 PM (After dinner).
     - Giant High-Contrast Button: `[ ✓ TAKE NOW ]`.
     - Immediate local optimistic update: tap transitions immediately to `✓ TAKEN · Saved`.
   - Routine Summary List: Morning (Taken ✓), Afternoon (None), Evening (Current).
   - Quick Voice Action Card: `[ 🎙 Talk to Dhatri ]`.

2. **Screen 2 — Incoming Dhatri Care Call (`incoming_call_screen.dart`)**:
   - Phone call style interface with pulsating avatar ring.
   - Large text: *"Dhatri — Your Care Companion"*.
   - Subtitle: *"Incoming evening health check-in"*.
   - Giant Green Action: `[ 📞 ANSWER ]` (72dp height).
   - Secondary Link: *"Remind me in 15 minutes"*.

3. **Screen 3 — Active Hindi Voice Call (`active_call_screen.dart`)**:
   - Explicit Textual State Banner:
     - `CALL CONNECTED`
     - `Dhatri is speaking...`
     - `Your turn — speak now`
     - `Listening...`
     - `Thinking...`
   - Animated visualizer: `DhatriAudioWaveform`.
   - Conversational Transcript Cards with authentic Hindi audio scripts:
     - **Turn 1**: 
       - Dhatri: *"नमस्ते रमेश जी। आज आप कैसा महसूस कर रहे हैं?"*
       - Patient: *"थोड़ा कमजोर महसूस कर रहा हूं।"*
     - **Turn 2 (Patient Memory Demonstration)**:
       - Context Tag: *"Recalled earlier weakness from 3 days ago"*
       - Dhatri: *"आपने कुछ दिन पहले भी कमजोरी की बात कही थी। क्या आज यह ज्यादा लग रही है?"*
       - Patient: *"हां, थोड़ा चक्कर भी आ रहा है।"*
     - **Closing**:
       - Dhatri: *"धन्यवाद रमेश जी। मैंने यह नोट कर लिया है और आपकी बेटी को सूचित कर दिया है। अपना ध्यान रखिए।"*
   - Interactive options: Large "Tap to Speak" microphone button + Quick Hindi response chips for zero-friction demo interaction.
   - Clear red `[ End Call ]` button.

4. **Screen 4 — Today's Medicines (`patient_medicines_screen.dart`)**:
   - Clean vertical list of cards for all prescribed drugs today.
   - Optimistic state update with undo snackbar.

5. **Screen 5 — Health Timeline (`patient_health_screen.dart`)**:
   - Scrollable history showing daily dose confirmations, reported feelings, and check-in logs.

6. **Screen 6 — Help & Caregiver Contact (`patient_help_screen.dart`)**:
   - Large red emergency card: *"In an emergency, call 112"*.
   - Dominant Caregiver button: `[ 📞 Call Ananya (Daughter) ]` with `tel:` intent.
   - One-tap help request: `[ ⚠ Something feels wrong — Alert Ananya ]`.

---

### Phase 5: Caregiver Experience (5 Screens)
*UX Focus: Triage and Rapid Action. Answer: "Does anyone need my attention?" and put the action directly beside the alert.*

1. **Screen 7 — Caregiver Home / Triage (`caregiver_home_screen.dart`)**:
   - Top Triage Counter: *"Today: 8 patients · 2 need attention"*.
   - **Urgent Needs Attention Section**:
     - 🚨 *Ramesh Kumar (72)* — Missed 8:00 PM Metformin dose (No response for 20 mins).
     - Direct Action Button: `[ 📞 CALL RAMESH ]` right on the alert card.
     - ⚠ *Ramesh Kumar (72)* — Repeated weakness reported (3 times in 7 days).
   - **All Patients List**:
     - Ramesh Kumar (⚠ Check-in needed)
     - Alice Smith (⚠ Medication missed)
     - John Sharma (✓ All good)
     - Lakshmi Devi (✓ All good)
   - Floating Action: `[ + Add Prescription ]`.

2. **Screen 8 — Alert Detail Screen (`alert_detail_screen.dart`)**:
   - Breakdown of the escalation timeline (Scheduled 8:00 PM -> Reminder sent 8:00 PM -> Escalated 8:20 PM).
   - Direct buttons: `[ Call Patient ]` and `[ Mark as Acknowledged ]`.

3. **Screen 9 — Patient Detail View (`patient_detail_screen.dart`)**:
   - Ramesh Kumar profile header with caregiver link status.
   - 7-Day Adherence ring (86%).
   - Active medications summary.
   - *"Dhatri Patient Memory"* expandable view showing stored longitudinal observations.
   - Action Button: `[ 🎙 Initiate Wellness Call Now ]` (triggers simulated call on patient screen).

4. **Screen 10 — Prescription Upload Screen (`prescription_upload_screen.dart`)**:
   - Clean upload interface: `[ Take Photo ]` or `[ Choose from Gallery ]`.
   - Includes 2 pre-packaged sample prescription images (e.g. Dr. Verma Clinic - Metformin & Amlodipine).
   - Animated progress state:
     - *"Reading prescription..."*
     - *"Extracting medicine names, dosages, timings, instructions..."*

5. **Screen 11 — AI Prescription Confirmation (`prescription_review_screen.dart`)**:
   - Mandatory human-in-the-loop safety banner:
     - *"AI extracted this schedule — review before activating."*
   - Editable draft medicine cards:
     - Medicine 1: Metformin 500 mg | 1 tablet, Twice daily | Morning + Evening (After meals).
     - Medicine 2: Amlodipine 5 mg | 1 tablet, Once daily | Morning.
   - Highlighted uncertainty badge: *"Please verify dosage"*.
   - Interactive Edit Bottom Sheet allowing name/timing/frequency adjustments.
   - Primary Action: `[ CONFIRM AND ACTIVATE SCHEDULE ]`.
   - Result: Adds medication to the active roster and generates today's dose events!

---

### Phase 6: Doctor Experience (2 Screens)
*UX Focus: Context, Longitudinal Trends & Review Flags. Answer: "What changed, and who needs clinical review?"*

1. **Screen 12 — Doctor Dashboard (`doctor_dashboard_screen.dart`)**:
   - Patient Selector: Ramesh Kumar (Age 72, Type-2 Diabetes & Hypertension).
   - Metrics Cards:
     - Medication Adherence: **86%** (down from 92% previous week).
     - Missed Doses: **2 this week**.
     - Wellness Check-ins: **7 completed**.
   - **AI Care Summary Card (Factual Synthesis)**:
     - *"Repeated weakness reported across 3 of the last 5 check-ins. Medication adherence declined from 92% to 86%. Patient noted mild dizziness during evening calls."*
     - Badge: `⚠ Clinical Review Recommended`.

2. **Screen 13 — Doctor Longitudinal Insight & Timeline (`doctor_patient_insight_screen.dart`)**:
   - Adherence trend chart over the last 14 days.
   - Symptom frequency breakdown:
     - Weakness: 3 reports (Max severity: 3/5).
     - Dizziness: 1 report (Severity: 2/5).
   - Correlated Timeline: Merged doses and clinical remarks.

---

### Phase 7: Interactive Demo Controller & Role Switcher
*Target Goal: Enable seamless recorded video demonstration in under 2 minutes.*

- Persistent yet unobtrusive floating **Demo Controller Bar**:
  - **Role Tab Switcher**: Quickly switch viewport between `[ Patient ]`, `[ Caregiver ]`, and `[ Doctor ]`.
  - **Event Trigger: "Simulate Dose Reminder"**: Immediately sends a reminder to the patient phone.
  - **Event Trigger: "Simulate Missed Dose"**: Fast-forwards grace period -> turns dose to `missed` -> fires live red alert to caregiver.
  - **Event Trigger: "Trigger Dhatri Call"**: Rings the patient phone with the Hindi care check-in.
  - **"Reset Seed Data"**: Resets back to the beginning of the demo journey.

---

## 3. Step-by-Step Execution Sequence

| Step # | Module | Key Deliverables | Verification Milestone |
|---|---|---|---|
| **Step 1** | Flutter Project Setup | Create `dhatri_flutter`, configure `pubspec.yaml` (fonts, icons, intl), verify clean compile. | Flutter app runs with empty shell. |
| **Step 2** | Theme & Accessible Design System | Implement `app_colors.dart`, `app_typography.dart`, `app_theme.dart`. | Large legible typography, high contrast, WCAG AA compliant. |
| **Step 3** | Domain Models & Mock Engine | Implement all models matching ARCHITECTURE.md §4, 7-day seed generator, and reactive Care Stream. | Unit test / verify mock state emits `CareUpdate` events. |
| **Step 4** | 12 Core UI Components | Build all `Dhatri*` widgets (Buttons, Chips, MedicationCard, AlertCard, TimelineItem, etc.). | Component catalog preview rendered cleanly without overflow. |
| **Step 5** | Patient Experience Screens | Build Patient Home (dominant Next Dose), Medicines tab, Health Timeline, and Help tab. | Optimistic "Take Now" transitions locally to "✓ TAKEN". |
| **Step 6** | Voice Call Simulation Screens | Build Incoming Call screen and Active Hindi Call screen with wave animation, transcript & memory card. | Simulated 2-turn dialogue works smoothly with Hindi scripts. |
| **Step 7** | Caregiver Screens | Build Caregiver Home (Triage counter, Alert cards with inline Call), Alert detail, and Patient detail. | Missed dose alert displays with immediate call action. |
| **Step 8** | Prescription Upload & Review | Build Upload screen (with sample photos) and AI Confirmation screen with editable pill cards. | Confirming schedule updates patient's today medications. |
| **Step 9** | Doctor Screens | Build Doctor Dashboard with AI Care Summary and Longitudinal Insight screen. | 86% adherence, 3x weakness symptom count, review badge rendered. |
| **Step 10** | Demo Toolbar & Video Flow Polish | Build floating Demo Controller; verify complete multi-day demo flow under 2 minutes. | Smooth role switching, deterministic event triggers, zero bugs. |

---

## 4. Video Recording Flow Verification (2-Minute Script)

1. **Scene 1 (Caregiver Upload)**: Caregiver selects sample prescription -> animated extraction -> reviews AI draft -> confirms schedule.
2. **Scene 2 (Patient Reminder)**: Switch to Patient -> 8:00 PM Metformin hero card shows "Next Medicine".
3. **Scene 3 (Missed Dose & Live Alert)**: Trigger "Simulate Missed Dose" -> Switch to Caregiver -> instant live red alert banner appears: *"Ramesh has not confirmed 8:00 PM dose"*.
4. **Scene 4 (Caregiver Call)**: Caregiver taps `[ CALL PATIENT ]`.
5. **Scene 5 (Incoming & Active Call)**: Switch to Patient -> Incoming call rings -> Patient answers -> Dhatri speaks Hindi -> Patient taps "कमजोरी लग रही है" -> Dhatri recalls 3-day-old weakness and asks context-aware follow-up.
6. **Scene 6 (Doctor Insight)**: Switch to Doctor -> Doctor dashboard shows 86% adherence, 3x weakness reports, and concise AI Care Summary recommending review.

