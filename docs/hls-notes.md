# HLS Security Notes

These notes document common security observations, misconfigurations, and testing considerations related to HTTP Live Streaming (HLS) implementations.

They are intended to support **authorized penetration testing, security research, and defensive assessments**.

---

## Overview of HLS

HTTP Live Streaming (HLS) is a media delivery protocol developed by Apple. It uses:
- `.m3u8` playlists
- Segmented media files (`.ts`, `.m4s`, `.mp4`)
- Optional encryption via `EXT-X-KEY`

HLS is widely used in web applications, mobile apps, and CDN-backed streaming platforms.

---

## Common HLS Misconfigurations

During security assessments, the following issues are frequently observed:

### 1. Publicly Accessible Playlists
- No authentication required to access `.m3u8` files
- Master playlists expose all available variants

### 2. Token Leakage
- Long-lived access tokens embedded directly in playlist URLs
- Tokens reused across multiple variants
- Tokens visible in client-side JavaScript or network logs

### 3. Missing or Weak Encryption
- Streams delivered without `EXT-X-KEY`
- Encryption keys accessible without authorization
- Static or predictable key URLs

### 4. Predictable Segment Paths
- Sequential or guessable segment filenames
- No request signing or origin protection
- Direct access to segments without playlist validation

### 5. CDN Misconfiguration
- Lack of origin access restrictions
- Inconsistent authorization between playlist and segments
- Missing rate limiting or request validation

---

## What to Look For During Testing

When assessing HLS implementations, consider:

- Presence and configuration of `EXT-X-KEY`
- Token lifetime and rotation behavior
- Authorization consistency across:
  - Master playlists
  - Variant playlists
  - Media segments
- Header behavior (cookies, authorization headers, referer)
- Access control enforcement at the CDN and origin level

---

## Defensive Recommendations

For secure HLS deployments:

- Enforce short-lived, signed URLs
- Restrict playlist and segment access at the CDN level
- Use encrypted streams with protected key delivery
- Monitor playlist access patterns for abuse
- Apply consistent authorization checks across all endpoints

---

## Ethical Notice

All observations and techniques described here are intended for **defensive security research and authorized testing only**.

Always obtain explicit permission before testing any media delivery system.
