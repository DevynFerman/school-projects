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

## Planned Architecture (High Level)

**Hardware (Initial):**
- Arduino Nano or Arduino Nano ESP32
- MB-102 solderless breadboard
- AHT10 temperature/humidity sensor (for early I²C practice)
- Level shifter (if required)
- External display (TBD)

**Software (Planned):**
- Microcontroller firmware to:
  - Poll or receive GitHub status updates
  - Parse and store last-known state
  - Drive display output
- A lightweight backend or GitHub API integration layer (TBD)
- Periodic polling with change detection logic

---

## Development Approach

This project is intentionally **stepwise**:

1. **Hardware First**
   - Correct wiring
   - Sensor communication
   - Stable power and signal paths

2. **Simple Feedback Loops**
   - LEDs or basic output before full display integration

3. **Incremental Software**
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

## Status

🚧 **Early prototyping phase**

Currently focused on:
- Breadboard layout
- Arduino placement
- Understanding I²C pin mapping and sensor wiring

Software and backend design will follow once the hardware foundation is solid.

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