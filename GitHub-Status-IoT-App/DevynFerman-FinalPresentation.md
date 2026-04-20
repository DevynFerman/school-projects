---
marp: true
size: 4:3
paginate: true
title: Final Presentation — Ambient GitHub PR Status Display
---

# Ambient GitHub PR Status Display
## Final Presentation

Devyn Ferman
CSC 494 — AI-Driven IoT System Development

---

## What I Set Out to Build

**Problem:** Constantly switching to GitHub to check PR status breaks focus.

**Solution:** A physical, always-on display that passively surfaces the right info — no tab switching required.

- Swift CLI polls GitHub on a configurable timer
- Sends status to an Arduino-driven 16x2 LCD over serial
- Priority logic: review requests → drafts → open PRs → all clear

---

## Progress Since S1P

**At S1P:**
- Hardware powered, LCD showing default squares (not yet text)
- Swift CLI skeleton running, first GitHub API call working

**Since S1P:**
- LCD displaying text via I2C firmware
- POSIX serial connection implemented in Swift
- Full GitHub polling — authored PRs + review-requested PRs
- Priority-based display logic and change detection
- Error recovery — API failures surface on the LCD, loop continues
- End-to-end validation with real hardware

---

## It Works

[Live demonstration]

```
swift run GitHubWatcher <username> <token> --wait 5 --watchTimeout 8
```

**Canvas:** https://nku.instructure.com/courses/88152/pages/individual-progress-devyn-ferman
**GitHub:** https://github.com/DevynFerman/school-projects

---

## Issues I Faced

**Hardware — shared ground**
The LCD wouldn't respond at all. Once I understood that I2C requires all devices to share a common ground reference, the fix was a single wire.

**Software — no serial abstraction in Swift**
Swift doesn't have a built-in serial port API. I had to drop into Darwin's C layer using POSIX `termios` — configuring baud rate, stop bits, and parity by hand.

**Architecture — the original plan was too complex**
The initial design had an ESP32 fetching a JSON status file over WiFi. Talking it through with AI made clear that a local Swift process sending messages directly to the Arduino over serial eliminated several layers that weren't earning their complexity.

---

## How AI Helped Me Solve Them

**Shared ground:** AI explained why I2C requires a shared ground reference and what the symptom of a missing one looks like — which matched exactly what I was seeing.

**POSIX serial:** AI walked me through the `termios` configuration pattern step by step. It's a C API from the 1980s with no modern documentation — I wouldn't have gotten through it quickly on my own.

**Architectural pivot:** AI helped me compare the two approaches side by side. The tradeoffs were obvious once I listed them out, and the simpler path was also the better fit for how I actually use the device.

---

## What I Learned from AI

AI was most useful as a **thinking partner**, not a code generator.

- It helped me ask better questions ("what do I actually need?" vs. "how do I implement X?")
- It shortened the feedback loop on unfamiliar domains — hardware wiring, POSIX APIs, GitHub Search API behavior
- It caught design problems early, before I spent time building the wrong thing

The key was treating AI output as something to understand and verify, not something to copy and run.

---

## Does It Match the Plan?

| Original Plan | What Shipped |
|---|---|
| ESP32 WiFi polling | Swift CLI on Mac |
| JSON status file | Direct serial messages |
| Always-on network device | Session-based background process |

The scope changed, but the problem and the goal didn't.
The final result is simpler, more reliable, and a better fit for how I actually work.

---

## Q & A

**GitHub:** https://github.com/DevynFerman/school-projects

**Canvas:** https://nku.instructure.com/courses/88152/pages/individual-progress-devyn-ferman
