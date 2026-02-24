# HLS Stream Analyzer

![Bash](https://img.shields.io/badge/language-bash-4EAA25?logo=gnu-bash\&logoColor=white)
![License](https://img.shields.io/github/license/404saint/hls-stream-analyzer)
![Status](https://img.shields.io/badge/status-active%20development-blue)
![Security Research](https://img.shields.io/badge/use--case-security%20research-critical)
![HLS](https://img.shields.io/badge/protocol-HLS-orange)

A Bash-based utility for **analyzing and reconstructing HTTP Live Streaming (HLS) media streams** in authorized security testing and research environments.

The analyzer inspects HLS playlist structures, evaluates segmentation behavior, and reconstructs streams for **offline inspection and documentation**. It is designed for transparency, minimal dependencies, and ethical use.

> **Scope:** This tool focuses on inspection, validation, and offline reconstruction of HLS streams.
> It does **not** attempt authentication bypass, DRM circumvention, or cryptographic attacks.

---

## Features

* Master and variant playlist detection
* Multi-variant processing (single or all variants)
* Absolute and relative segment URL handling
* Parallel (fast) and sequential (stealth) download modes
* Segment integrity verification (checksums)
* Offline stream reconstruction and remuxing
* Clean, per-variant output isolation
* Minimal runtime dependencies

---

## Architecture Overview

<p align="center">
  <img src="docs/hls-stream-analyzer-architecture.png"
       alt="HLS Stream Analyzer execution flow diagram"
       width="900">
</p>

---

## How It Works (High-Level)

1. An HLS playlist URL (`.m3u8`) is provided and validated
2. The playlist is classified as **master** or **variant**
3. Variant playlists are selected and retrieved
4. Media segment URLs are extracted and normalized
5. Segments are downloaded using the selected mode
6. Segment integrity is verified
7. The stream is reconstructed and remuxed to MP4
8. Basic stream metadata is displayed for verification

No decryption, DRM handling, or evasion logic is performed at any stage.

---

## Common Misconfigurations Observed

During authorized assessments, this tool is useful for identifying:

* Publicly accessible master or variant playlists
* Tokenized URLs embedded directly in playlist files
* Long-lived or reusable access tokens
* Inconsistent access controls across variants
* Missing or misconfigured encryption directives (`EXT-X-KEY`)

These findings often indicate broader weaknesses in media delivery security.

---

## Requirements

* `bash` (>= 4.x)
* `wget`
* `ffmpeg`
* `aria2` *(optional — required for fast mode)*

---

## Installation

```bash
git clone https://github.com/404saint/hls-stream-analyzer.git
cd hls-stream-analyzer
chmod +x hls-analyzer.sh
```

---

## Usage

```bash
./hls-analyzer.sh
```

The analyzer runs in **interactive mode**, guiding the user through:

* Playlist classification
* Variant selection
* Download mode selection
* Stream reconstruction

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

This structure supports clean multi-variant analysis and reporting.

---

## Security Considerations

* DRM is **not bypassed**
* Encrypted streams are **not decrypted**
* No exploit payloads or obfuscation techniques are used
* Intended strictly for **authorized security research**

---

## Non-Goals

This project intentionally does **not** attempt to:

* Bypass authentication or authorization mechanisms
* Circumvent DRM or licensing controls
* Evade monitoring, rate limits, or detection
* Perform cryptographic attacks

These constraints are deliberate and aligned with ethical security practices.

---

## Disclaimer

This project is intended for **educational purposes and authorized security testing only**.

Do **not** use this tool against systems you do not own or do not have explicit permission to test.
The author assumes no responsibility for misuse.

---

## Author

**RUGERO Tesla**
Ethical Hacker & Freelance Penetration Tester
