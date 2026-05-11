#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <output_dir>"
  exit 1
fi

OUT_DIR="$1"
rm -rf "$OUT_DIR"
mkdir -p "$OUT_DIR"

make_card() {
  local card_dir="$1"
  local camera_prefix="$2"

  mkdir -p "$card_dir/DCIM/100${camera_prefix}" "$card_dir/AUDIO" "$card_dir/META"

  # Representative camera media + sidecar files
  dd if=/dev/urandom of="$card_dir/DCIM/100${camera_prefix}/${camera_prefix}_0001.MXF" bs=1m count=8 status=none
  dd if=/dev/urandom of="$card_dir/DCIM/100${camera_prefix}/${camera_prefix}_0002.MXF" bs=1m count=12 status=none
  dd if=/dev/urandom of="$card_dir/AUDIO/${camera_prefix}_0001.WAV" bs=1m count=2 status=none

  cat > "$card_dir/META/${camera_prefix}_0001.XML" <<XML
<clip>
  <name>${camera_prefix}_0001</name>
  <camera>${camera_prefix}</camera>
</clip>
XML

  # Common exclusion-pattern candidates
  mkdir -p "$card_dir/.Spotlight-V100" "$card_dir/.fseventsd" "$card_dir/PRIVATE/AVCHD/BDMV"
  echo "ignore" > "$card_dir/.DS_Store"
  echo "journal" > "$card_dir/.fseventsd/fseventsd-uuid"
  echo "cache" > "$card_dir/.Spotlight-V100/store.db"

  # Mixed nesting to exercise path handling and traversal protection
  mkdir -p "$card_dir/DCIM/100${camera_prefix}/SUB/DEEP"
  dd if=/dev/urandom of="$card_dir/DCIM/100${camera_prefix}/SUB/DEEP/${camera_prefix}_A001.MOV" bs=1m count=4 status=none
}

make_card "$OUT_DIR/source_card_A" "ACAM"
make_card "$OUT_DIR/source_card_B" "BCAM"

mkdir -p "$OUT_DIR/destination_primary" "$OUT_DIR/destination_backup"

echo "Fixtures created under: $OUT_DIR"
echo "Sources:"
echo "  - $OUT_DIR/source_card_A"
echo "  - $OUT_DIR/source_card_B"
echo "Destinations:"
echo "  - $OUT_DIR/destination_primary"
echo "  - $OUT_DIR/destination_backup"
