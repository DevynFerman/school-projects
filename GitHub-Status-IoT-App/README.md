# GitHub PR Status IoT Display

## Overview

This project is an **IoT-based status display** designed to surface GitHub pull request (PR) information in a persistent, glanceable way. The goal is to offload low-value context switching (opening GitHub, checking notifications, refreshing dashboards) into a small physical device that passively monitors and reports meaningful changes.

The device periodically polls GitHub for updates related to:
- My open pull requests
- Pull requests that require my review
- Review status changes (approved, changes requested, ready to merge)
- Potentially other GitHub signals (CI status, merge readiness, comments)

When a relevant change is detected, the system visually notifies me via a connected display (e.g., flashing, scrolling text, or status indicators).

This project is intentionally **incremental and exploratory**, with early emphasis on hardware fundamentals before software complexity.

---

## In-development

### Runtime direction (current)

The active design direction is to run a **local Swift background process** during active work hours, rather than relying on always-on remote execution.

Current approach:
- Build a Swift CLI using `swift-argument-parser`
- Support `--once` (single poll) and `--watch` (continuous polling) modes
- Run as a lightweight local background process while I am actively working
- Keep poll intervals conservative (for example 1-5 minutes) to minimize CPU/network usage
- Persist last-known PR state locally for reliable change detection across restarts
- Emit concise status output that can be bridged to IoT display behavior

Why this direction:
- Matches real usage: I only need it while actively working
- Easier local iteration and debugging
- Better fit for direct communication with locally connected hardware
- Keeps credentials and execution context on my development machine

---

## Deprecated (Original Runtime Direction)

The sections below are kept for project history and learning context. Any references to always-on or not-yet-decided runtime/backend execution should be treated as **deprecated** in favor of the local Swift background process described above.

---

## Intentions & Learning Goals

This project is part of an **AI-Driven IoT System Development course** and serves multiple purposes:

### 1. Learn Core IoT Fundamentals (Primary Goal)
I am brand new to:
- Breadboarding and wiring
- Microcontrollers (Arduino Nano / Nano ESP32)
- Sensors and peripherals
- Power, ground, and signal routing

Early milestones focus on:
- Correct physical layout
- Reliable wiring
- Understanding I²C (Inter-Integrated Circuit) communication
- Reading sensor data successfully (e.g., AHT10 temperature/humidity sensor)

Software complexity will intentionally lag behind hardware mastery.

---

### 2. Bridge IoT with Real Engineering Workflows
Rather than a purely academic demo, this project is designed to integrate with **real-world developer workflows**, specifically:
- GitHub PR review cycles
- CI/CD signal awareness
- Async status monitoring

This aligns closely with my professional background in DevOps and platform engineering, making the project both practical and motivating.

---

### 3. Design for Passive Awareness
The device is **not meant to replace GitHub**. Instead, it provides:
- Ambient awareness
- Low-interruption signaling
- Quick insight without cognitive overhead

The display should communicate *that something changed*, not necessarily all details.

---

## Planned Architecture (High Level) [Deprecated]

**Hardware (Initial):**
- Arduino Nano or Arduino Nano ESP32
- MB-102 solderless breadboard
- AHT10 temperature/humidity sensor (for early I²C practice)
- Level shifter (if required)
- External display (TBD)

**Software (Planned) [Deprecated]:**
- Microcontroller firmware to:
  - Poll or receive GitHub status updates
  - Parse and store last-known state
  - Drive display output
- A lightweight backend or GitHub API integration layer (TBD)
- Periodic polling with change detection logic

---

## Development Approach [Partially Deprecated]

This project is intentionally **stepwise**:

1. **Hardware First**
   - Correct wiring
   - Sensor communication
   - Stable power and signal paths

2. **Simple Feedback Loops**
   - LEDs or basic output before full display integration

3. **Incremental Software** (implementation language/runtime now evolving toward Swift local background process)
   - Minimal viable logic
   - Poll → compare → notify pattern

4. **Optional Enhancements**
   - Smarter filtering
   - Multiple repositories
   - CI status integration
   - Custom alert prioritization

---

## Non-Goals (For Now)

- Production-grade security
- Complex UI interactions
- High-frequency polling
- Large-scale GitHub organization analytics

These may be explored later but are explicitly out of scope for early iterations.

---

## Status [Updated]

🚧 **Early prototyping phase**

Currently focused on:
- Breadboard layout
- Arduino placement
- Understanding I²C pin mapping and sensor wiring
- Defining Swift-based local PR polling architecture and process lifecycle

Software and backend design are being implemented incrementally alongside hardware progress, with local background execution as the current runtime target.

---

## Why This Project Matters to Me

This project sits at the intersection of:
- Physical computing (new skill set)
- Developer productivity
- Systems thinking
- Practical, real-world signal design

It’s intentionally small in scope, but representative of the kinds of systems I want to design: tools that quietly reduce friction and cognitive load.

---

## Notes

This README will evolve as the project matures. Early documentation prioritizes **intent and learning objectives** over finalized implementation details.
