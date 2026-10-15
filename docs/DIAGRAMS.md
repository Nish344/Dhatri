# Dhatri — Architecture & data-flow diagrams

Source Mermaid (`.mmd`) and rendered PNGs live in [`docs/diagrams/`](diagrams/).
Brand palette matches the app: primary `#0A686D`, light `#E6F3F3`, success `#15803D`, warning `#B45309`, background `#F7F9FA`.

Use the PNGs in slides, reports, and demos. Edit the `.mmd` files, then re-render:

```bash
# Chromium must be available for mermaid-cli (puppeteer).
cat > /tmp/puppeteer-chromium.json <<'EOF'
{"executablePath": "/usr/bin/chromium", "args": ["--no-sandbox"]}
EOF
for f in docs/diagrams/*.mmd; do
  mmdc -i "$f" -o "${f%.mmd}.png" -b transparent -w 1800 -H 1200 -p /tmp/puppeteer-chromium.json
done
```

These diagrams match `ARCHITECTURE.md` (what is actually built).

| # | Diagram | What it shows |
|---|---------|----------------|
| 01 | [System architecture](diagrams/01_system_architecture.png) | Flutter roles ↔ Serverpod ↔ Postgres/pgvector/storage ↔ Gemini + Sarvam |
| 02 | [Prescription → doses](diagrams/02_prescription_to_doses.png) | Caregiver upload → Gemini extract → confirm → DoseEvent + remind |
| 03 | [Missed-dose alert](diagrams/03_missed_dose_alert.png) | remind → grace → escalate → Alert → live caregiver CareUpdate |
| 04 | [Hindi care-call pipeline](diagrams/04_care_call_flow.png) | open → STT → memory → Gemini → symptoms/alerts → TTS |
| 05 | [Data model](diagrams/05_data_model.png) | Core ER: Profile, Rx, Medication, DoseEvent, WellnessCheck, memory, Alert |
| 06 | [CareUpdate bus](diagrams/06_care_update_bus.png) | The one rule: write Postgres, then post to `patient_{id}` |

## Suggested slide order

1. **Fig — System architecture** (01)
2. **Fig — End-to-end medication data flow** (02)
3. **Fig — Missed dose → caregiver alert** (03)
4. **Fig — Wellness care call** (04)
5. **Fig — Data model** (05)
6. **Fig — Real-time CareUpdate bus** (06)
