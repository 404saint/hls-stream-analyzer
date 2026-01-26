# HLS Stream Analyzer

A Bash-based tool for analyzing and reconstructing HTTP Live Streaming (HLS) media streams.

This project is designed for **security research, traffic analysis, and authorized penetration testing** of media delivery systems. It allows researchers to inspect HLS playlist structures, analyze segmentation behavior, and reconstruct streams for offline inspection.

---

## Features

- Detects **master vs variant** HLS playlists
- Supports **multiple resolutions / variants**
- Handles **relative and absolute segment URLs**
- Fast (parallel) and stealth (sequential) download modes
- Segment integrity verification (checksums)
- Offline stream reconstruction
- Clean per-variant output structure
- Minimal dependencies

---

## Why This Tool Exists

HLS streams are frequently misconfigured in real-world environments. During security assessments, testers may encounter:

- Publicly accessible playlists
- Missing authentication or authorization
- Token leakage in playlist URLs
- Improper CDN access controls
- Missing or misconfigured encryption (`EXT-X-KEY`)

This tool assists in **analyzing HLS implementations**, validating protections, and documenting security findings in authorized testing scenarios.

---

## Requirements

- bash (>= 4.x)
- wget
- ffmpeg
- aria2 *(optional — required for fast mode)*

---

## Installation

```bash
git clone https://github.com/404saint/hls-stream-analyzer.git
cd hls-stream-analyzer
chmod +x hls-analyzer.sh
````

---

## Usage

### Basic Execution

```bash
./hls-analyzer.sh
```

The tool runs in **interactive mode** and will guide you through the analysis process.

---

### Step 1: Provide HLS Playlist URL

You will be prompted to enter an HLS playlist URL (`.m3u8`):

```
Enter playlist (.m3u8) URL:
```

Supported inputs:

* Master playlists
* Variant playlists
* Absolute or relative URLs

---

### Step 2: Variant Selection (Master Playlists)

If a **master playlist** is detected, available variants (resolutions/bitrates) are listed:

```
Available variants:
1) low/playlist.m3u8
2) mid/playlist.m3u8
3) high/playlist.m3u8
```

You may select:

* A **single variant** by number
* **All variants** by typing `all`

If a variant playlist is provided directly, this step is skipped.

---

### Step 3: Download Mode Selection

Choose the desired download behavior:

```
1) Fast (parallel, aria2)
2) Stealth (sequential, wget)
```

#### Fast Mode

* Uses `aria2`
* Parallel segment downloads
* Suitable for lab environments and controlled testing

#### Stealth Mode

* Uses `wget`
* Sequential downloads
* Reduced request footprint
* Better suited for cautious testing scenarios

---

### Step 4: Processing & Reconstruction

For each selected variant, the tool performs the following:

1. Downloads the variant playlist
2. Extracts and normalizes segment URLs
3. Downloads media segments
4. Generates integrity checksums
5. Reconstructs the media stream
6. Converts the output to MP4
7. Displays stream metadata

Progress and status messages are shown during execution.

---

## Output Structure

Each variant is processed in its own directory:

```
hls_output/
└── variant_name/
    ├── variant.m3u8
    ├── segments.txt
    ├── checksums.md5
    ├── full_video.ts
    └── output.mp4
```

This structure prevents data overlap and supports multi-variant analysis.

---

## Security Considerations

* This tool **does not bypass DRM**
* Encrypted streams (`EXT-X-KEY`) are **not decrypted**
* No exploit payloads or obfuscation mechanisms are included
* Intended strictly for **authorized security testing**

---

## Disclaimer

This project is intended for **educational purposes and authorized security testing only**.

Do **NOT** use this tool against systems you do not own or do not have explicit permission to test.
The author assumes no responsibility for misuse.

---

## Author

**RUGERO Tesla**
Ethical Hacker & Freelance Penetration Tester

