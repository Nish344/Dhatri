#!/usr/bin/env bash
# Synthetic Indian clinic prescriptions for extraction gate testing (not real PHI).
set -euo pipefail
cd "$(dirname "$0")"

write_rx() {
  local file="$1"
  local body="$2"
  convert -size 900x1200 xc:white \
    -font DejaVu-Sans -pointsize 22 -fill black -gravity NorthWest \
    -annotate +36+36 "$body" \
    -quality 92 "$file"
}

write_rx simple_metformin.jpg "Dr. Verma Clinic, Bengaluru
Patient: Ramesh Kumar, 72 yrs
Date: 01 Oct 2026

Rx
Tab Metformin 500 mg
1-0-1 after food x 30 days

Dr. Verma MD"

write_rx simple_amlodipine.jpg "City Care Hospital
Patient: Ramesh Kumar
01/10/2026

Tab Amlodipine 5 mg
OD before breakfast x 30 days

Signature"

write_rx multi_diabetes_htn.jpg "Dr. Verma Clinic
Ramesh Kumar (72)

1. Tab Metformin 500 mg BD after meals x 1 month
2. Tab Amlodipine 5 mg OD morning x 30 days
3. Tab Atorvastatin 20 mg HS x 30 days

Dr. Verma"

write_rx multi_three_times.jpg "Green Valley Polyclinic
Patient: Lakshmi Devi

Cap Amoxicillin 500 mg TDS x 5 days
Syrup Cetirizine 5 ml HS x 7 days
Tab Paracetamol 650 mg SOS

Dr. Rao"

write_rx hard_handwriting_style.jpg "Dr. Verma Clinic — Bengaluru
Pt: Ramesh Kumar   Age 72

Rx (handwritten style abbreviations)
Tab Metformin 500mg  1-0-1  PC  x 30d
Tab Glimepiride 1mg  OD  before BF  x 30d
Tab Telmisartan 40mg  OD  x 1 month
Syp. Iron folic 10ml  OD  x 14 days

Dr. Verma MD (Reg 12345)"

echo "Wrote 5 sample JPGs in $(pwd)"
