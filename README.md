# HLS Stream Analyzer

A Bash-based tool for analyzing and reconstructing HTTP Live Streaming (HLS) media streams.

This tool is designed for **security research, traffic analysis, and authorized penetration testing** of media delivery systems. It allows researchers to inspect HLS playlist structures, analyze stream segmentation, and reconstruct streams for offline inspection.

---

## Features

- Detects **master vs variant** HLS playlists
- Supports **multiple resolutions / variants**
- Handles **relative and absolute segment URLs**
- Fast (parallel) and stealth (sequential) download modes
- Segment integrity verification (checksums)
- Offline stream reconstruction
- Minimal dependencies
- Clean per-variant output structure

---

## Why This Tool Exists

HLS streams are commonly misconfigured in real-world environments. During security assessments, testers may encounter:

- Unauthenticated or unencrypted HLS endpoints
- Token leakage in playlist URLs
- Improper CDN access controls
- IDOR issues in media delivery
- Missing or misconfigured `EXT-X-KEY` encryption

This tool assists in **analyzing HLS implementations**, validating protections, and documenting security findings.

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
