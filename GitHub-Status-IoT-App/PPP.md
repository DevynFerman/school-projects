---
marp: true
title: GitHub PR Status IoT Display (PPP)
description: Project Planning Presentation for AI-Driven IoT System Development
theme: default
paginate: true
size: 16:9
header: GitHub PR Status IoT Display
footer: PPP • AI-Driven IoT System Development
---

<!-- _class: lead -->

# GitHub PR Status IoT Display
## Project Planning Presentation (PPP)

- Course: AI-Driven IoT System Development
- Platform: Arduino Nano / Arduino Nano ESP32 + breadboard peripherals

---

# 1.1) Problem to solve

## What problem am I solving?

Developers (literally me) lose time and focus repeatedly checking GitHub for pull request updates:
- “Do I have PRs waiting on review?”
- “Do I owe someone a review?”
- “Did a review / CI status change?”

---

# 1.2) Why it matters

## Why is solving it important?

- Reduces low-value context switching (tabs, refreshes, notification overload)
- Improves response time to PR review/merge events
- Enables  (what I'm coining as) **passive awareness**: “something changed” without interrupting deep work
- Creates a tangible IoT artifact that connects software workflow signals to the physical world

---

# 2) Team / Topic

## Topic focus

**Software focus:** I'm building an application *on top of IoT hardware* that makes developer workflow signals glanceable. Similar to a push notification, but even less detailed, to be ADHD friendly.

Concrete scope for this project:
- Poll GitHub for PR signals (mine, needing my review, review state changes)
- Detect changes vs last-known state
- Drive a simple physical output (LED patterns → display output)

---

# 2) What I’m building

## Planned system

- **Input:** GitHub PR signals (GitHub API)
- **Compute:** lightweight change detection + alert rules
- **Output:** ambient display (LEDs first, then a small display)

---

# 3) Two topics I will learn (with AI)

## Software topic

**GitHub integration + state change detection**
- GitHub API auth + request patterns
- Parsing/formatting a compact PR status model
- Poll → compare → notify loop

## Hardware topic

**I²C peripherals + troubleshooting**
- Correct wiring on a breadboard (power/ground/signal)
- I²C scanning + pin mapping for the chosen Arduino board
- Using an I²C device as practice (AHT10 now, display next)

---

# 4.1) Usage of time

## 1st iteration → what I must learn for the 2nd iteration

Hardware fundamentals (I know absolutely nothing):
- Breadboard layout, stable power rails, clean wiring
- I²C basics: address scan, read a sensor reliably (AHT10)
- Basic output loop: LED indicators for “OK / change / error”

Software fundamentals (Shhh, I actually already know how to do this):
- GitHub API basics (auth, endpoints, rate limits)
- Decide architecture: direct polling vs local backend proxy. I'm leaning towards polling for simplicity.

---

# 4.2) Usage of time

## 2nd iteration → what feature I will make

**Minimum viable “PR status display” feature**
- Fetch PR summary on a schedule (e.g., every 1–5 minutes)
- Detect meaningful changes (new PR, review requested, approved/changes requested)
- Display status:
  - Counts (mine open / needs my review)
  - “Change detected” alert behavior (blink/flash/scroll)
  - Error state (network/auth/rate limit)

---

# 5) Final goal

- Build a working prototype I can demo and include in my portfolio
  - Clear “before/after” productivity story: fewer GitHub checks, better awareness
- Maybe extend the functionality: CI status, multiple repos, smarter alert priorities
- If the prototype goes well, I would like to create a higher quality final product and install it on my desk at work!
    - I'm thinking an integration with an LLM that can determine whether or not it's a quick or involved update and indicate respectively.
    - This could also measure importance or urgency on follow-ups.
