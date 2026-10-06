# Dhatri UI/UX Design Guide for Coding & Design Agents

> **Project:** Dhatri  
> **Logo treatment:** **Dhātrī**  
> **Written product name:** **Dhatri**  
> **Platform:** Flutter  
> **Primary users:** Older patients, caregivers, doctors  
> **Submission format:** Recorded hackathon video
>
> **Purpose:** This document is the implementation-facing UI/UX specification for Dhatri. A coding/design agent should be able to use this file as the primary visual and interaction guide when building the Flutter application.

---

# 1. Product UX Goal

Dhatri is not just a medication reminder.

It is an AI-assisted care companion that:

```text
Prescription
    ↓
Medication schedule
    ↓
Reminder
    ↓
Dose confirmation / missed-dose detection
    ↓
Caregiver escalation
    ↓
Voice wellness calls
    ↓
Patient memory
    ↓
Doctor/caregiver insight
```

The UI must communicate this without becoming complex.

## Core UX principle

> **The patient should always know what to do next.**

For older users, the application should feel closer to a familiar phone/reminder experience than to a medical dashboard.

For caregivers and doctors, the application should become progressively more information-dense and operational.

---

# 2. Role-Specific Design Philosophy

Do not use one identical interface density for every role.

| Role | UX priority | Information density |
|---|---|---|
| Patient | Clarity, confidence, one action at a time | Low |
| Caregiver | Awareness + action | Medium |
| Doctor | Context + trends + review | High |

### Patient question

> **“What do I need to do right now?”**

### Caregiver question

> **“Does anyone need my attention?”**

### Doctor question

> **“What changed, and who needs review?”**

This should drive layout decisions throughout the application.

---

# 3. Accessibility Is a Product Requirement

Accessibility is not an optional polish step for Dhatri because older adults are a core audience.

Flutter's current accessibility guidance recommends at least **48×48 dp** tap targets, sufficient contrast, and layouts that continue to work when users increase system font size. Flutter also recommends testing with large system font settings, screen readers, and color-vision/grayscale conditions. [Flutter accessibility: UI design & styling](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)

Flutter's release accessibility guidance also recommends:

- screen-reader testing with TalkBack and VoiceOver;
- at least 4.5:1 contrast where applicable;
- tappable targets of at least 48×48;
- testing at large text/display scale factors;
- ensuring important actions can be undone. [Flutter accessibility checklist](https://docs.flutter.dev/ui/accessibility)

NHS accessibility guidance similarly emphasizes AA-level contrast, clear focus states, giving users time to read and act, and never relying on color or spatial position alone to communicate meaning. [NHS accessibility design guidance](https://service-manual.nhs.uk/accessibility/design)

## Dhatri minimum standards

### Touch targets

```text
Absolute minimum: 48 × 48 dp
Primary patient action: ~56–64 dp height
Major voice/call action: ~64–72 dp
```

Do not make tiny icons independently tappable unless the complete hit area meets the target requirement.

### Text

Patient interfaces should start larger than normal consumer-app defaults.

Recommended starting scale:

```text
Page title:       28–32 sp
Section title:    22–24 sp
Primary action:   20–22 sp
Body:             18–20 sp
Supporting text:  16–18 sp
```

These are Dhatri design starting points, not accessibility limits.

### Important Flutter rule

**Do not lock the UI to a fixed `textScaleFactor`.**

Flutter respects OS-level text-size settings. The layout must expand/reflow gracefully at larger sizes rather than suppressing accessibility scaling.

Use modern Flutter `TextScaler`/responsive layout practices and test with the largest practical system text size.

### Contrast

Target WCAG AA-level contrast:

```text
Normal text: ≥ 4.5:1
Large text:  ≥ 3:1
```

Do not use pale gray text on white simply because it looks fashionable.

### Color independence

Never communicate state using color alone.

Bad:

```text
Green = Taken
Red = Missed
```

Good:

```text
✓ TAKEN
⚠ MISSED
○ UPCOMING
```

Color should reinforce the semantic state, not be the only signal.

---

# 4. Visual Direction

## Desired aesthetic

> **Calm + trustworthy + warm + modern + highly legible**

Dhatri should feel medical enough to communicate reliability without looking like a hospital administration system.

### Use

- large typography;
- generous spacing;
- high contrast;
- simple cards;
- restrained color palette;
- strong hierarchy;
- recognizable icons;
- familiar interaction metaphors;
- subtle rounded corners;
- meaningful illustrations/avatars;
- clear status labels.

### Avoid

- excessive glassmorphism;
- tiny text;
- very pale secondary text;
- excessive gradients;
- neon UI;
- over-animated screens;
- dense dashboards for patients;
- five or more equally prominent buttons;
- icons without labels where ambiguity is possible;
- color-only status indicators;
- modal stacks / nested dialog flows.

---

# 5. Dhatri Color Strategy

The exact palette can be finalized during implementation, but use these principles.

## Patient experience

Prefer a calm neutral/light background and one strong primary brand color.

Example conceptual system:

```text
Background       → warm/neutral light
Surface          → white
Primary          → deep teal / green-blue
Text             → very dark neutral
Success          → accessible green
Warning          → accessible amber/orange
Error            → accessible red
Info             → strong blue
```

Do not rely on extremely soft pastel colors for critical state.

Use semantic status colors in combination with:

- icon;
- label;
- shape;
- layout position.

---

# 6. Navigation Philosophy

Dhatri should be **linear and predictable**.

## Patient navigation

Recommended primary destinations:

```text
Home
Medicines
Health
Help
```

Do not create a large navigation drawer with dozens of destinations.

The main task should normally be reachable in one or two taps.

## Caregiver navigation

Suggested:

```text
Home
Patients
Alerts
Calls
Profile
```

## Doctor navigation

Suggested:

```text
Dashboard
Patients
Insights
Timeline
Profile
```

Keep role-specific navigation separate rather than creating a single huge universal navigation structure.

---

# 7. Screen Set

The first polished release/demo should prioritize roughly these screens.

## Patient

1. Home / Today's Care
2. Incoming Dhatri Care Call
3. Active Voice Call
4. Medicines
5. Health Timeline

## Caregiver

6. Caregiver Home
7. Alert Detail
8. Patient Detail

## Doctor

9. Doctor Dashboard
10. Patient Insight / Timeline

## Shared

11. Prescription Upload
12. AI Extracted Prescription Confirmation

These are enough to communicate the complete product story without building an unnecessarily large UI surface.

---

# 8. Patient Screen 01 — Home / Today's Care

## Goal

Answer one question immediately:

> **What do I need to do now?**

The current/next action should dominate the screen.

### Recommended structure

```text
┌─────────────────────────────────────┐
│                                     │
│  Good morning, Ramesh               │
│  Tuesday, 6 October                 │
│                                     │
│  YOUR NEXT MEDICINE                 │
│                                     │
│  ┌───────────────────────────────┐  │
│  │                               │  │
│  │  💊  Metformin                │  │
│  │      500 mg                   │  │
│  │                               │  │
│  │      8:00 PM                  │  │
│  │      After dinner             │  │
│  │                               │  │
│  │  ┌─────────────────────────┐  │  │
│  │  │       ✓ TAKE NOW        │  │  │
│  │  └─────────────────────────┘  │  │
│  └───────────────────────────────┘  │
│                                     │
│  TODAY                              │
│                                     │
│  ✓ Morning medicine                 │
│  ✓ Afternoon medicine               │
│  ● Evening medicine                 │
│                                     │
│  [ Talk to Dhatri ]                 │
│                                     │
└─────────────────────────────────────┘
```

## Rules

- Current action must be visually dominant.
- Do not lead with statistics.
- Do not show a dense month calendar.
- Show only as much future information as the patient needs.
- “Take Now” should be much more prominent than secondary actions.
- Show explicit state labels such as `TAKEN`, `MISSED`, `UPCOMING`.

A current healthcare dashboard reference also uses a “daily routine first” layout rather than starting from the underlying data structure. This is a useful design principle for Dhatri. [Patient Health Dashboard UI reference](https://dribbble.com/shots/27708008-Patient-Health-Dashboard-UI-Design)

---

# 9. Patient Screen 02 — Incoming Dhatri Care Call

This screen should mimic a familiar phone call experience.

## Goal

Minimize anxiety and cognitive load.

### Recommended structure

```text
┌─────────────────────────────────────┐
│                                     │
│                 ◯                   │
│              Dhatri                 │
│         Your care companion         │
│                                     │
│       Incoming health call          │
│                                     │
│          ●  ANSWER                  │
│                                     │
│       Remind me later               │
│                                     │
└─────────────────────────────────────┘
```

After answer:

```text
┌─────────────────────────────────────┐
│               Dhatri                │
│                                     │
│       “Are you feeling well         │
│              today?”                │
│                                     │
│            🎙 Listening...          │
│                                     │
│      [ Repeat ]   [ End Call ]      │
└─────────────────────────────────────┘
```

## Critical rule

Do not turn an active call into a dashboard.

The patient should primarily understand:

1. Who is calling?
2. Why?
3. Is it my turn to speak?
4. How do I end/repeat?

---

# 10. Voice Conversation State

Use an explicit state system.

Example:

```text
Dhatri is speaking
Your turn — speak now
Dhatri is listening
Thinking...
```

Add animation/iconography, but always keep a textual state label so the user does not have to infer the state from color or motion.

Recommended state sequence:

```text
CALL CONNECTED
      ↓
Dhatri is speaking
      ↓
Your turn
      ↓
Listening
      ↓
Processing
      ↓
Dhatri responds
```

Avoid rapid UI changes that may confuse an older user.

---

# 11. Patient Screen 03 — Today's Medicine / Tracker

Do not create a dense calendar grid.

Use a vertical list of cards.

### Example

```text
TODAY'S MEDICINES

┌────────────────────────────────────┐
│ 💊 MORNING — 8:00 AM               │
│                                    │
│ Blood Pressure Medicine            │
│ 1 tablet                           │
│                                    │
│ ✓ TAKEN                            │
└────────────────────────────────────┘

┌────────────────────────────────────┐
│ 💊 LUNCH — 1:00 PM                 │
│                                    │
│ Vitamin D                           │
│ 1 capsule                          │
│                                    │
│ [ MARK AS TAKEN ]                  │
└────────────────────────────────────┘
```

### Interaction rule

After a successful action:

```text
MARK AS TAKEN
        ↓
✓ TAKEN
```

The visual state should update immediately locally.

The UI should not wait for a slow network round trip before reflecting the user's tap.

Persist the action asynchronously.

---

# 12. Patient Screen 04 — Health Timeline

This should make the patient's journey understandable at a glance.

```text
HEALTH TIMELINE

TODAY
✓ Evening medicine
⚠ Feeling weak

YESTERDAY
✓ Morning medicine
🙂 Feeling well

2 DAYS AGO
❌ Evening medicine missed
⚠ Weakness reported

5 DAYS AGO
⚠ Mild fatigue reported
```

The timeline is important because Dhatri's unique value is longitudinal continuity.

---

# 13. Caregiver Screen — Home

The caregiver dashboard is not for reading every detail.

It is for **triage**.

### Primary hierarchy

```text
TODAY

8 patients
2 need attention

NEEDS ATTENTION

┌─────────────────────────────────┐
│ ⚠ Alice Smith · 84              │
│ Missed 12 PM medicine           │
│ No response to reminder         │
│                                 │
│ [ CALL PATIENT ]                │
└─────────────────────────────────┘

ALL PATIENTS

John       ✓ All good
Ramesh     ⚠ Check-in needed
Alice      ⚠ Medication missed
Lakshmi    ✓ All good
```

## Important interaction principle

Put the action directly beside the problem.

Do not force:

```text
Alert
→ Patient profile
→ Medication
→ Event
→ Call
```

when the caregiver's immediate need is simply:

> **Call patient.**

---

# 14. Doctor Dashboard

The doctor dashboard can be denser than the caregiver UI.

The doctor needs:

- patient overview;
- medication adherence;
- wellness patterns;
- AI summary;
- recent timeline;
- review flags.

### Recommended layout

```text
RAMESH KUMAR · 72

Medication adherence
86%

Missed doses
2 this week

Wellness check-ins
7

──────────────────────────

AI CARE SUMMARY

Repeated weakness reported
across the last 5 days.

Medication adherence has
declined compared with the
previous week.

⚠ Review recommended

──────────────────────────

PATIENT TIMELINE
...
```

## Key principle

Put **AI summary before raw analytics**.

The dashboard should answer:

> “What changed?”

before answering:

> “Show me every underlying data point.”

---

# 15. Prescription Upload Screen

Keep the upload workflow extremely simple.

```text
ADD PRESCRIPTION

┌──────────────────────────────┐
│                              │
│       📷                     │
│                              │
│  Take a photo of the         │
│  prescription                │
│                              │
│  [ TAKE PHOTO ]              │
│                              │
│  [ CHOOSE FROM GALLERY ]     │
│                              │
└──────────────────────────────┘
```

After upload:

```text
READING PRESCRIPTION...

Extracting:
✓ Medicine names
✓ Dosages
✓ Times
✓ Duration
✓ Instructions
```

---

# 16. AI Prescription Confirmation Screen

This is a critical human-in-the-loop screen.

Never silently convert OCR/AI extraction directly into active medication schedules.

### Recommended layout

```text
REVIEW YOUR MEDICINES

┌─────────────────────────────────┐
│ Metformin 500 mg                │
│ 1 tablet · 2 times/day          │
│ Morning + Evening               │
│ After food                      │
│                                 │
│ [ EDIT ]                        │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ Amlodipine 5 mg                 │
│ 1 tablet · Once/day              │
│ Morning                          │
│                                 │
│ [ EDIT ]                        │
└─────────────────────────────────┘

⚠ Please check the extracted
   schedule before continuing.

[ CONFIRM SCHEDULE ]
```

This should be framed as:

> **AI extracted this schedule. Review before activating.**

The interface should make correction easy.

---

# 17. Components to Standardize

Create reusable Flutter components rather than styling every screen independently.

Recommended components:

```text
DhatriPrimaryButton
DhatriSecondaryButton
DhatriStatusChip
DhatriMedicationCard
DhatriAlertCard
DhatriPatientCard
DhatriTimelineItem
DhatriCallState
DhatriInsightCard
DhatriSectionHeader
DhatriEmptyState
DhatriErrorState
DhatriBottomActionBar
```

NHS's design system is a useful reference for reusable cards, tags, notification banners, warning callouts, task lists, summary lists, file uploads, buttons, errors, and navigation components. [NHS Design System components](https://service-manual.nhs.uk/design-system/components)

---

# 18. Agent-Level Layout Rules

## Rule 1 — No modal stacks

Avoid:

```text
Dialog
   ↓
Dialog
   ↓
Dialog
```

Older users can easily lose context.

Prefer:

- dedicated full-screen route;
- full-screen confirmation;
- persistent bottom sheet when appropriate.

## Rule 2 — Avoid automatic context switching

Do not unexpectedly navigate the user to another page because of a background event.

Important actions should have an intentional transition.

Flutter explicitly recommends avoiding context changes without appropriate confirmation. [Flutter accessibility](https://docs.flutter.dev/ui/accessibility)

## Rule 3 — Keep primary action obvious

Each screen should normally have one primary action.

Do not make six buttons look equally important.

## Rule 4 — Keep error states actionable

Instead of:

> “Something went wrong.”

show:

> “We couldn't save the dose confirmation. Try again.”

with:

> `[ TRY AGAIN ]`

## Rule 5 — Never make status color-only

Always pair:

```text
color + icon + label
```

---

# 19. Responsive / Accessibility Implementation

Coding agents must test at:

### Device sizes

- small phone;
- standard phone;
- large phone;
- tablet where applicable.

### Text scales

Test with:

```text
Default
Large
Very Large
Maximum practical system setting
```

The UI should:

- reflow;
- wrap;
- expand vertically;
- never clip critical text;
- never hide action labels because of scale.

### Screen readers

Test:

- Android TalkBack
- iOS VoiceOver

All actionable controls should have intelligible accessibility labels.

Examples:

```text
“Mark Metformin as taken”
“Call Alice”
“Open patient timeline”
“Repeat Dhatri's question”
“End call”
```

Flutter explicitly recommends screen-reader testing with TalkBack and VoiceOver. [Flutter accessibility checklist](https://docs.flutter.dev/ui/accessibility)

---

# 20. Touch / Gesture Rules for Older Users

Prefer:

- tap;
- large buttons;
- straightforward vertical scrolling.

Avoid making essential actions depend on:

- swipe-only gestures;
- long press;
- drag and drop;
- tiny icon affordances.

If a swipe exists as a convenience, provide a normal tap alternative.

---

# 21. Patient Copywriting Rules

Use plain language.

### Prefer

```text
Today's medicines
Next medicine
Take now
I took it
Remind me later
Talk to Dhatri
Call caregiver
How are you feeling?
Something feels wrong
```

### Avoid

```text
Medication adherence event
Initiate wellness interaction
Acknowledge medication administration
Trigger caregiver escalation
Clinical observation
Generate longitudinal health signal
```

These technical terms can appear in internal/admin contexts, not patient-facing screens.

---

# 22. AI Summary Writing Style

AI-generated caregiver/doctor summaries should be:

- short;
- factual;
- traceable to underlying observations;
- free of unsupported medical diagnosis;
- explicit about uncertainty.

Good:

> “Patient reported weakness in 3 of the last 5 wellness check-ins. Two medication doses were missed this week.”

Avoid:

> “Patient is likely developing a serious medical condition.”

Dhatri should surface patterns and recommend human review rather than presenting itself as an autonomous diagnosis engine.

---

# 23. Patient Memory UI

The semantic/vector-memory system should not be exposed as technical RAG jargon.

Call it:

> **Dhatri Patient Memory**

The UI concept is:

```text
CURRENT
“I still feel weak.”

RELEVANT RECENT HISTORY

• Weakness reported 2 days ago
• Fatigue reported 6 days ago
• One missed evening dose

Dhatri:
“You mentioned feeling weak a few days ago.
Is it getting worse today?”
```

This should feel like a companion remembering the patient, not like a chatbot searching a vector database.

---

# 24. Caregiver Alert Design

Use a clear priority hierarchy.

### Normal

```text
✓ All medicines confirmed
```

### Attention

```text
⚠ Dose not confirmed
```

### Important

```text
⚠ Repeated wellness concern
```

### High priority

```text
🔴 Immediate caregiver review recommended
```

Do not create alert fatigue by escalating every minor event.

---

# 25. Doctor Insight Design

Doctor insights should combine:

```text
Adherence trend
+
Wellness trend
+
Relevant patient memory
+
Recent timeline
```

Example:

```text
PATIENT INSIGHT

Medication adherence:
92% → 86% this week

Wellness:
Weakness mentioned 3 times
in the last 5 days

Relevant history:
Similar fatigue mentioned
last month

Review recommended.
```

---

# 26. Motion & Animation

Animation should communicate state, not decoration.

Good:

- subtle speaking/listening pulse;
- medication confirmation check animation;
- alert arrival animation;
- smooth screen transitions.

Avoid:

- constant floating animations;
- large parallax effects;
- bouncing controls;
- long transitions;
- animated gradients behind text.

For older patients, animation should never delay access to the next action.

---

# 27. Empty States

Never leave a blank page.

### Example

```text
NO MEDICINES TODAY

You're all caught up.

[ VIEW HEALTH TIMELINE ]
```

### Caregiver

```text
NO ALERTS

Everyone is on track today. ✓
```

### Doctor

```text
NO NEW INSIGHTS

No new patient concerns
require review today.
```

---

# 28. Loading States

Prefer meaningful loading messages.

Instead of:

```text
Loading...
```

use:

```text
Reading prescription...
Checking today's schedule...
Preparing your care summary...
Connecting your call...
Listening...
```

For the patient UI, avoid complex skeleton loaders when a simple message is easier to understand.

---

# 29. Offline / Poor Connectivity UX

Dhatri should be designed for imperfect connectivity.

### Patient

Local actions should immediately show the user-facing state:

```text
✓ TAKEN
Saving...
```

Then:

```text
✓ TAKEN
Saved
```

or if offline:

```text
✓ TAKEN
Will sync when connected
```

Do not make the patient repeatedly tap a button because the server is slow.

### Caregiver/doctor

Clearly show:

```text
Updated just now
Last updated 2 min ago
Offline — showing last known state
```

---

# 30. Recorded Video Considerations

The Dhatri submission is a **recorded video**, not a live judge interaction.

Therefore:

- design polished state transitions;
- use deterministic demo data;
- make important events visible;
- compress multi-day journeys into the timeline;
- avoid requiring a human reviewer to wait for scheduled events;
- make Serverpod-powered events visually understandable;
- ensure every key AI capability has a visible result.

## Recommended video journey

```text
Prescription photo
      ↓
AI extraction
      ↓
Caregiver confirms schedule
      ↓
Reminder
      ↓
Missed dose
      ↓
Live caregiver alert
      ↓
Hindi Dhatri call
      ↓
Patient reports weakness
      ↓
Patient Memory retrieves previous weakness
      ↓
Dhatri asks context-aware follow-up
      ↓
Doctor sees longitudinal insight
```

This is the preferred story for the final product video.

---

# 31. Visual Reference Board

These references are **inspiration and pattern references only**, not templates to copy. Use them to understand information hierarchy, card composition, spacing, and healthcare interaction patterns.

## A. Elderly Care — CareLink

Useful for:

- senior-care information architecture;
- caregiver/family workflows;
- medication + health monitoring;
- accessible card-based presentation.

[CareLink — Elderly Care mobile app UI, Dribbble](https://dribbble.com/shots/27342041-CareLink-Elderly-Care-mobile-App-UI)

## B. Senior Medication / Wellness — Elderly Take Care

Useful for:

- medication reminders;
- emergency access;
- appointment/health support;
- simple senior-facing mobile patterns.

[Elderly Take Care App, Dribbble](https://dribbble.com/shots/26344051-Elderly-Take-Care-App)

## C. Patient Health Dashboard

Useful for:

- “daily routine first” information hierarchy;
- medication checklist;
- calm health dashboard;
- surfacing what matters today.

[Patient Health Dashboard UI, Dribbble](https://dribbble.com/shots/27708008-Patient-Health-Dashboard-UI-Design)

## D. Doctor + Patient Dashboard

Useful for:

- role-specific dashboard architecture;
- modular healthcare cards;
- patient records;
- real-time communication;
- responsive health dashboard patterns.

[Smart Healthcare Dashboard UI for Doctors & Patients, Dribbble](https://dribbble.com/shots/26363902-Smart-Healthcare-Dashboard-UI-for-Doctors-Patients)

## E. Patient Profile / Clinical Dashboard

Useful for:

- patient profile hierarchy;
- medication schedule;
- clinical history;
- analytics;
- longitudinal medical summary.

[Patient Profile Dashboard UI, Dribbble](https://dribbble.com/shots/27263664-Patient-Profile-Dashboard-UI)

## F. Senior Care + AI Family App

Useful for:

- family/caregiver dashboard;
- AI recap;
- medication;
- care team;
- health monitoring.

[Kinwell — AI-Powered Senior Care Family App UI Kit, Dribbble](https://dribbble.com/shots/27432702-Kinwell-AI-Powered-Senior-Care-Family-App-UI-Kit)

## G. Aging / Wellness / Medication / Mood

Useful for:

- older-adult UX;
- medication tracking;
- wellness tracking;
- caregiver connectivity;
- calm visual direction.

[Wellness Aging Care Mood & Meds Tracking App, Behance](https://www.behance.net/gallery/242023175/UIUX-for-Wellness-Aging-Care-Mood-Meds-Tracking-app)

---

# 32. Authoritative Accessibility References

## Flutter

Use these as the implementation authority for Flutter accessibility:

- [Flutter — UI design & styling accessibility](https://docs.flutter.dev/ui/accessibility/ui-design-and-styling)
- [Flutter — Accessibility overview/checklist](https://docs.flutter.dev/ui/accessibility)

Key verified requirements:

```text
Minimum tap target: 48×48 dp
Support system text scaling
Test screen readers
Use sufficient contrast
Test color-vision/grayscale conditions
Make important actions reversible where applicable
```

## NHS Design System

Use this as a mature reference for accessible healthcare information architecture:

- [NHS Design System](https://service-manual.nhs.uk/design-system)
- [NHS Components](https://service-manual.nhs.uk/design-system/components)
- [NHS Accessibility — Design](https://service-manual.nhs.uk/accessibility/design)

Particularly useful components/patterns:

```text
Buttons
Cards
Tags
Notification banners
Warning callouts
Task lists
Summary lists
File upload
Error messages
Error summaries
Navigation
```

---

# 33. Agent Instruction — What to Build

When implementing any new Dhatri screen, the coding/design agent should answer these questions first:

### 1. Who is the user?

Patient / Caregiver / Doctor

### 2. What is their immediate question?

```text
Patient → What do I do now?
Caregiver → Who needs attention?
Doctor → What changed?
```

### 3. What is the single primary action?

If there is no obvious primary action, simplify the screen.

### 4. Can the screen survive:

- 200%+ practical text scale;
- screen-reader labels;
- 48×48 minimum targets;
- grayscale;
- poor connectivity;
- small phone width?

### 5. Is any important meaning conveyed only by color?

If yes, add:

```text
icon + text + color
```

### 6. Does the screen require a popup?

Prefer:

- route;
- bottom sheet;
- inline expansion;

over stacked dialogs.

---

# 34. Agent Instruction — What NOT to Do

Do not:

- create a dense patient dashboard;
- use fixed text scaling that overrides accessibility;
- hide labels behind icons;
- rely on color only;
- require swipe gestures for essential tasks;
- use tiny controls;
- use medical jargon in patient copy;
- make the patient confirm the same action repeatedly;
- create nested dialogs;
- overuse charts;
- put AI summaries below the fold when they are the main insight;
- generate diagnosis-like claims from wellness conversations;
- add decorative motion that delays the primary task;
- invent a new visual style on each screen.

---

# 35. Design Review Checklist

Before approving a screen:

## Accessibility

- [ ] 48×48 dp minimum interactive targets
- [ ] Large primary patient controls
- [ ] Text survives large system scaling
- [ ] Contrast checked
- [ ] Color is not the only status indicator
- [ ] Screen-reader labels make sense
- [ ] Important actions are visible and reversible where appropriate

## UX

- [ ] User role is obvious
- [ ] Primary question is obvious
- [ ] One primary action
- [ ] Navigation is predictable
- [ ] No unnecessary modal stack
- [ ] Copy is plain language

## Visual

- [ ] Calm and trustworthy
- [ ] Consistent spacing
- [ ] Consistent typography
- [ ] Consistent component shapes
- [ ] No unnecessary decorative noise
- [ ] Status hierarchy is clear

## Dhatri-specific

- [ ] Patient UI is simpler than caregiver UI
- [ ] Caregiver UI is action-oriented
- [ ] Doctor UI prioritizes insight and timeline
- [ ] Voice state is explicit
- [ ] Patient memory is expressed as useful context, not technical RAG
- [ ] Important demo states are visually obvious

---

# 36. Final Design North Star

The entire product should feel like:

> **A calm, trusted health companion for the patient, an alert system for the caregiver, and a concise source of longitudinal context for the doctor.**

The patient should never feel:

> “I need to learn how this app works.”

They should feel:

> **“Dhatri is telling me what I need to do.”**

The caregiver should feel:

> **“Dhatri will tell me when something needs my attention.”**

The doctor should feel:

> **“Dhatri helps me understand what has changed.”**

That is the UX foundation of the product.
