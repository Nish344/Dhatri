# Dhatri (धात्री) — Frontend Application

An AI-assisted remote-care companion for elderly patients, caregivers, and doctors.

Built for the **Serverpod Hackathon ("Build Something Real")**.

---

## What Has Been Built

The complete Flutter frontend application is fully implemented in `dhatri_flutter/` with an interactive, standalone **Mock Data & Real-Time Simulation Engine**.

### 1. Role-Specific UX Architecture
- **👴 Patient Experience (Low density, large targets ≥ 60dp)**:
  - **Today's Care (Home)**: Dominant "NEXT MEDICINE" hero card with instant optimistic confirmation (`✓ TAKE NOW` -> `✓ TAKEN · Saving...` -> `✓ TAKEN · Confirmed`).
  - **Incoming Care Call**: Full-screen telephony interface (`Answer` / `Remind me later`).
  - **Active Hindi Voice Call**: Explicit states (`Dhatri is speaking` -> `Your turn — speak now` -> `Listening...` -> `Thinking...`), animated audio waveforms, conversational Hindi speech bubbles, and **Dhatri Patient Memory** drawer retrieving past observations.
  - **Medicines Tab**: Chronological prescription checklist.
  - **Health Timeline**: Longitudinal 7-day health journey.
  - **Help Tab**: Emergency 112 button, direct daughter contact (`📞 Call Ananya`), and `"Something feels wrong"` one-tap alert button.

- **👩 Caregiver Experience (Triage & immediate action)**:
  - **Caregiver Home**: Triage counter (`8 patients · 2 need attention`), priority alert cards with inline `[ 📞 CALL RAMESH ]` buttons.
  - **Alert Detail**: Escalation chronology (Scheduled 8:00 PM -> Reminder sent -> Grace period expired -> Escalated).
  - **Patient Detail**: Longitudinal adherence, active prescriptions, Patient Memory view, and `"Initiate Wellness Call Now"` remote trigger.
  - **Prescription Upload & Review**: Camera/gallery upload with animated OCR extraction and **mandatory Human-in-the-Loop review** before schedule activation.

- **🩺 Doctor Experience (Clinical context & trends)**:
  - **Doctor Dashboard (Read-only)**: Clinical indicators (86% adherence, 2 missed doses, 7 check-ins).
  - **AI Care Summary Card**: Concise factual synthesis with uncertainty flags and `⚠ Clinical Review Recommended` badge.
  - **Symptom Frequency**: Weakness (3 reports, max severity 3/5), Dizziness (1 report).
  - **Longitudinal Clinical Timeline**: Merged dose history and check-in observations.

### 2. Standalone Simulation & Reactive Care Stream
- **Seeded 7-day realistic journey for Ramesh Kumar (72)** matching `ARCHITECTURE.md` §4 and `docs/DEMO.md`.
- **Reactive WebSocket Care Stream simulation (`MockCareStream`)** broadcasting real-time `CareUpdate` events (`DoseEvent`, `Alert`, `WellnessCheck`, `Prescription`).
- **Simulated Sarvam AI / Gemini Pipeline (`MockVoiceEngine`)** supporting authentic Hindi speech recognition, text-to-speech, and Patient Memory retrieval.

### 3. Built-in Presentation Toolbar
- Floating demo controller overlay at the bottom:
  - Switch viewports instantly: `[ Patient ]` | `[ Caregiver ]` | `[ Doctor ]`.
  - `🚨 Trigger Missed Dose`: Advances time past grace period -> triggers live caregiver alert banner.
  - `📞 Ring Care Call`: Rings the patient phone with Dhatri's Hindi health check-in.
  - `↺ Reset Data`: Restores initial clean demo dataset.

---

## How to Run

1. Navigate to the frontend directory:
   ```bash
   cd dhatri_flutter
   ```

2. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application on your connected device, emulator, or Chrome:
   ```bash
   flutter run
   ```

---

## 2-Minute Video Recording Guide

Follow this sequence to record the hackathon demo video:

1. **Scene 1 — Prescription Upload & Review**:
   - Start in **Caregiver** role.
   - Tap `+ Add Prescription` -> tap `Take Photo (Demo Rx)`.
   - Watch the animated AI extraction steps.
   - On the Review screen, show the safety banner, edit the bedtime dosage, and tap `CONFIRM AND ACTIVATE SCHEDULE`.

2. **Scene 2 — Patient Reminder**:
   - Use the Demo Toolbar to switch to **Patient** role.
   - Show the dominant Next Dose hero card (Metformin 500 mg at 8:00 PM).

3. **Scene 3 — Missed Dose & Live Alert**:
   - On the Demo Toolbar, tap `🚨 Trigger Missed Dose`.
   - Switch to **Caregiver** role -> watch the instant live red alert appear: *"Ramesh has not confirmed his 8:00 PM Metformin medication"*.

4. **Scene 4 — Caregiver Initiates Call**:
   - Tap `[ 📞 CALL RAMESH ]` or open Ramesh's profile and tap `Initiate Wellness Call Now`.

5. **Scene 5 — Hindi Voice Care Call**:
   - Switch to **Patient** role -> incoming call rings -> tap `ANSWER`.
   - Dhatri speaks: *"नमस्ते रमेश जी। आज आप कैसा महसूस कर रहे हैं?"*
   - Tap the quick response chip: *"थोड़ा कमजोर महसूस कर रहा हूं।"*
   - Watch Dhatri retrieve previous weakness from 3 days ago via **Patient Memory**:
     *"आपने 3 दिन पहले भी कमजोरी की बात कही थी। क्या आज यह पहले से ज्यादा लग रही है?"*
   - Tap `"हां, चलने में भी परेशानी हो रही है।"* -> Dhatri acknowledges and informs the daughter.

6. **Scene 6 — Doctor Dashboard**:
   - Switch to **Doctor** role.
   - Show the 86% adherence rate, 3 weakness reports in 7 days, and the factual AI Care Summary recommending human review.

