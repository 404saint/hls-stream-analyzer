#!/bin/bash

# === HLS Stream Analyzer ===
# Author: 404saint
# Purpose: HLS playlist analysis & offline reconstruction
# -----------------------------------------

set -euo pipefail
IFS=$'\n\t'

WORKDIR="hls_output"
mkdir -p "$WORKDIR"

echo "======================================="
echo "        HLS Stream Analyzer v1.1        "
echo "======================================="

# === Ask for playlist link ===
read -rp "Enter playlist (.m3u8) URL: " PLAYLIST_URL

# === Validate input ===
if [[ ! "$PLAYLIST_URL" =~ ^https?:// ]]; then
    echo "ERROR: Invalid URL format"
    exit 1
fi

# === Download playlist ===
PLAYLIST_FILE="$WORKDIR/playlist.m3u8"
if ! wget -q "$PLAYLIST_URL" -O "$PLAYLIST_FILE"; then
    echo "ERROR: Failed to download playlist"
    exit 1
fi

BASE_URL="$(dirname "$PLAYLIST_URL")"

# === Detect master vs variant ===
if grep -qE "^#EXT-X-STREAM-INF" "$PLAYLIST_FILE"; then
    echo "[*] Master playlist detected"

    mapfile -t VARIANTS < <(grep -E "\.m3u8" "$PLAYLIST_FILE")

    if [ "${#VARIANTS[@]}" -eq 0 ]; then
        echo "ERROR: No variants found"
        exit 1
    fi

    echo "Available variants:"
    for i in "${!VARIANTS[@]}"; do
        printf "%d) %s\n" "$((i+1))" "${VARIANTS[$i]}"
    done

    read -rp "Choose resolution number (or type 'all'): " CHOICE

    if [ "$CHOICE" = "all" ]; then
        SELECTED_VARIANTS=("${VARIANTS[@]}")
    else
        INDEX=$((CHOICE-1))
        SELECTED_VARIANTS=("${VARIANTS[$INDEX]}")
    fi
else
    echo "[*] Variant playlist detected"
    SELECTED_VARIANTS=("$(basename "$PLAYLIST_URL")")
fi

# === Ask for speed mode ===
echo "Download speed modes:"
echo "1) Fast (parallel, aria2)"
echo "2) Stealth (sequential, wget)"
read -rp "Choose speed mode [1/2]: " SPEED

if [ "$SPEED" = "1" ] && ! command -v aria2c >/dev/null 2>&1; then
    echo "ERROR: aria2c not installed"
    exit 1
fi

# === Process each variant ===
for VARIANT in "${SELECTED_VARIANTS[@]}"; do
    VARIANT_NAME="$(basename "$VARIANT" .m3u8)"
    VARIANT_DIR="$WORKDIR/$VARIANT_NAME"
    mkdir -p "$VARIANT_DIR"

    VARIANT_URL="$BASE_URL/$VARIANT"
    echo "[*] Processing variant: $VARIANT_URL"

    VARIANT_PLAYLIST="$VARIANT_DIR/variant.m3u8"
    wget -q "$VARIANT_URL" -O "$VARIANT_PLAYLIST" || {
        echo "ERROR: Failed to download variant"
        continue
    }

    # === Extract segments ===
    mapfile -t SEGMENTS < <(grep -E "\.(ts|mp4|m4s)" "$VARIANT_PLAYLIST")

    if [ "${#SEGMENTS[@]}" -eq 0 ]; then
        echo "ERROR: No media segments found"
        continue
    fi

    SEGMENT_LIST="$VARIANT_DIR/segments.txt"
    : > "$SEGMENT_LIST"

    for SEG in "${SEGMENTS[@]}"; do
        if [[ "$SEG" =~ ^https?:// ]]; then
            echo "$SEG" >> "$SEGMENT_LIST"
        else
            echo "$BASE_URL/$SEG" >> "$SEGMENT_LIST"
        fi
    done

    echo "[*] Downloading segments..."
    if [ "$SPEED" = "1" ]; then
        aria2c -i "$SEGMENT_LIST" -d "$VARIANT_DIR" \
            --summary-interval=1 \
            --console-log-level=warn \
            --max-tries=5 \
            --retry-wait=3
    else
        wget --show-progress -i "$SEGMENT_LIST" -P "$VARIANT_DIR" \
            --tries=5 --waitretry=3 -q
    fi

    echo "[*] Verifying segment checksums..."
    find "$VARIANT_DIR" -type f \( -name "*.ts" -o -name "*.mp4" -o -name "*.m4s" \) \
        -exec md5sum {} + > "$VARIANT_DIR/checksums.md5"

    echo "[*] Concatenating segments..."
    OUTPUT_TS="$VARIANT_DIR/full_video.ts"
    : > "$OUTPUT_TS"

    find "$VARIANT_DIR" -type f \( -name "*.ts" -o -name "*.mp4" -o -name "*.m4s" \) \
        | sort | while read -r FILE; do
            cat "$FILE" >> "$OUTPUT_TS"
        done

    echo "[*] Converting to MP4..."
    OUTPUT_MP4="$VARIANT_DIR/output.mp4"
    ffmpeg -y -loglevel error -i "$OUTPUT_TS" -c copy "$OUTPUT_MP4"

    echo "[*] Metadata:"
    ffmpeg -i "$OUTPUT_MP4" 2>&1 | grep -E "Duration|Stream"

    echo "[+] Finished variant: $VARIANT_NAME"
done

echo "======================================="
echo " 🎉 Processing complete — see $WORKDIR "
echo "======================================="
