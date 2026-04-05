# Learning With AI

This repository documents what I am learning with AI support for my course project.

## FOR PEER REVIEWERS

My updates for my learning with AI repo are appended to the end of the README! Simply scroll down and you'll be able to see them there, thank you!

## Purpose

I am using AI as a learning assistant to:
- break down unfamiliar technical domains,
- accelerate experimentation,
- and document what I learned in a way others can review.

## Two Learning Goals

### 1) Software Domain Goal

**Topic:** Use the GitHub API (`gh api`) from a background-thread application.

**Why I want/need to learn this:**
- My project depends on reliable PR status polling.
- I want this to run locally while at work, without blocking normal development workflows.
- I need to understand polling loops, state comparison, and process lifecycle in a real app.

**What I want to learn:**
- How to query GitHub PR data efficiently with `gh api` (REST and/or GraphQL).
- How to build a lightweight background process (Swift CLI with `swift-argument-parser`).
- How to design a poll -> compare -> notify loop with persisted state.
- How to manage practical concerns: auth, rate limits, retries, and logging.

**How I will learn it with AI:**
- Ask AI to explain endpoint/query options and tradeoffs for my use case.
- Ask AI to generate and refine small prototypes (single poll, then watch mode).
- Use AI to review my design for race conditions, duplicate alerts, and failure handling.
- Use AI to create test scenarios for status changes (new PR, review requested, CI change).

---

### 2) Hardware Domain Goal

**Topic:** Use an external screen to display project information.

**Why I want/need to learn this:**
- The project goal is passive awareness through a physical display.
- A screen provides better glanceable status.
- I need practical hardware integration experience (wiring + display communication, etc.).

**What I want to learn:**
- How to select and wire a compatible display module for my board setup.
- How to communicate with the display reliably (I2C).
- How to map PR states to simple visual patterns (counts, icons, short text, alert state).
- How to handle display update timing and error states in a stable loop.

**How I will learn it with AI:**
- Ask AI for wiring sanity checks and pin mapping guidance before powering hardware.
- Ask AI to help interpret API response details and initialization steps.
- Use AI to iterate display layouts that are readable and low cognitive load.
- Ask AI to help troubleshoot failed updates using observed behavior and logs.

---

## Learning Method

For each topic, I'll be repeating this cycle:
1. Define a small milestone.
2. Ask AI for options and a concrete plan.
3. Implement and test locally, asking questions along the way.
4. Capture results, mistakes, and next changes in this repository.

## Current Status

- Software goal: planning and initial architecture decisions in progress.
- Hardware goal: preparing external display integration path after foundational wiring practice.

## Weekly Progress Template

Template for weekly manager reports.

```md
## Week of YYYY-MM-DD

### Goal 1: gh api in background-thread app (Software)
- Planned:
- Completed:
- Blockers:
- AI prompts/support used:
- Evidence (files/commits):
- Next week:

### Goal 2: External screen integration (Hardware)
- Planned:
- Completed:
- Blockers:
- AI prompts/support used:
- Evidence (files/commits):
- Next week:
```

## Progress Checks

### Week of 2026-02-01

**Goal 1: gh api in background-thread app**
- Status: `Planning complete`
- Completed:
  - Project scope and intent documented.
  - Learning-with-AI area created.
- Evidence:
  - `GitHub-Status-IoT-App/README.md`
  - `Learning-With-AI/README.md`

**Goal 2: External screen integration**
- Status: `Problem framing complete`
- Completed:
  - External display use case and passive-awareness intent documented.
- Evidence:
  - `GitHub-Status-IoT-App/README.md`
  - `GitHub-Status-IoT-App/PPP.md`

### Week of 2026-02-08

**Goal 1: gh api in background-thread app**
- Status: `Scaffolding started`
- Completed:
  - Workflow placeholders added for GitHub status checks/testing.
  - Initial auth script path created for local experimentation.
- Evidence:
  - `.github/workflows/check-pr-status.yml`
  - `.github/workflows/workflow-testing`
  - `GitHub-Status-IoT-App/Scripts/auth-with-gh.sh`

**Goal 2: External screen integration**
- Status: `No implementation yet`
- Completed:
  - No screen-specific code or wiring artifacts committed yet.
- Evidence:
  - n/a

### Week of 2026-02-15

**Goal 1: gh api in background-thread app**
- Status: `Core scaffold in progress`
- Completed:
  - Swift executable project created with `swift-argument-parser`.
  - Async CLI entrypoint with watcher-related arguments and polling settings.
  - Credentials model and watcher manager structure added.
  - First GitHub API call implemented (`GET /users/{username}` with auth header).
  - Endpoint files created for PR and code-review status expansion.
- Evidence:
  - `GitHub-Status-IoT-App/GitHubWatcher/Package.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/GitHubWatcher.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Models/Credentials.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Models/WatcherManager.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/Autheticate.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/PullRequestStatus.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/CodeReviewStatus.swift`

**Goal 2: External screen integration**
- Status: `Pending`
- Completed:
  - Continued planning references in project docs.
- Evidence:
  - `GitHub-Status-IoT-App/PPP.md`
  - `GitHub-Status-IoT-App/README.md`

### Week of 2026-03-31

**Goal 1: gh api in background-thread app**
- Status: `Complete`
- Completed:
  - PR fetch endpoint implemented across all user repos (`GET /repos/{owner}/{repo}/pulls`)
  - Review-requested PR search implemented via GitHub Search API (`GET /search/issues`)
  - Priority-based display logic: review requests > draft PRs > open PR count > all clear
  - Change detection compares display messages between cycles — only updates LCD on change
  - Poll loop optimized: user profile and repos fetched once at startup, only PR data refreshed per cycle
  - Error recovery: API failures caught, error state displayed on LCD, polling continues
  - Unused CLI arguments (password, name, email) commented out and marked for review
  - Redundant method parameter pattern in API layer cleaned up
  - Configurable `--port` option added for serial port path
- Evidence:
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/GitHubGetters.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/GitHubWatcher.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/PullRequestStatus.swift`
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/CodeReviewStatus.swift`

**Goal 2: External screen integration**
- Status: `Complete`
- Completed:
  - Arduino sketch receives serial messages and displays on 16x2 I2C LCD
  - Serial communication implemented in Swift using POSIX termios (9600 baud, 8N1)
  - Protocol: pipe-delimited `topLine|bottomLine\n` format, 16-char truncation per line
  - Static test sketch created for hardware validation without serial
  - End-to-end hardware validation complete with real Arduino + LCD connected
  - File renamed from `TestArduinoSerialPort.swift` to `ArduinoSerialConnection.swift`
- Evidence:
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/ArduinoSerialConnection.swift`
  - `Arduino/GitHubWatcher_IoT/GitHubWatcher_IoT.ino`
  - `Arduino/LCD-StatusMessage-Static/LCD-StatusMessage-Static.ino`

## Current Status

- Software goal: **Complete.** Swift CLI polls GitHub, detects changes, and sends status to Arduino.
- Hardware goal: **Complete.** Arduino receives serial messages and displays on I2C LCD. End-to-end validated.

## MVP Status

The project is a working end-to-end prototype. Both learning goals have been achieved.
