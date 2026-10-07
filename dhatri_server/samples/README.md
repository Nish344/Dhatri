# Prescription extraction samples

Synthetic clinic-style JPGs for the Wed **4/5 gate** (not real patient data).

```bash
cd dhatri_server
./samples/generate_samples.sh   # regenerate images
export GEMINI_API_KEY=...       # or use shared.geminiApiKey in config/passwords.yaml
export GEMINI_MODEL=gemini-3.5-flash-lite
dart run bin/ai_smoke.dart gate samples
```

Rules live in `expected.json`.
