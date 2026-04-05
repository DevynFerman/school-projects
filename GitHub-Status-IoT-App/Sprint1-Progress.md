---
marp: true
title: GitHub PR Status IoT Display - Sprint 1 Progress
description: Brief progress update on implementation and learning milestones
theme: default
paginate: true
size: 16:9
header: GitHub PR Status IoT Display
footer: Sprint 1 Progress
---

<!-- _class: lead -->

# Sprint 1 Progress
## GitHub PR Status IoT Display

- Course: AI-Driven IoT System Development
- Focus: local Swift watcher + IoT display path

---

# Problem and Goal

## Problem
- Too much context switching to check PR/review updates in GitHub
- Important status changes are easy to miss during focused work

## Goal
- Build passive, glanceable awareness via IoT output
- Poll GitHub PR/review signals and surface meaningful changes

---

# What I Completed So Far

- Defined project scope and architecture in:
  - `GitHub-Status-IoT-App/README.md`
  - `GitHub-Status-IoT-App/PPP.md`
- Added initial workflow placeholders for status-check experiments:
  - `.github/workflows/check-pr-status.yml`
  - `.github/workflows/workflow-testing`
- Created Swift executable project:
  - `GitHub-Status-IoT-App/GitHubWatcher/Package.swift`

---

# Software Progress (Implemented)

- Swift CLI scaffolded with `swift-argument-parser`
- Async entry command in:
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/GitHubWatcher.swift`
- Runtime options added:
  - `--wait` (poll interval, minutes)
  - `--watchTimeout` (session limit, hours)
- Core models added:
  - `Credentials`
  - `WatcherManager`
  - typed `GitHubUser` response model

---

# GitHub API Progress

- Implemented authenticated user fetch in:
  - `GitHub-Status-IoT-App/GitHubWatcher/Sources/GitHubWatcher/Endpoints/GitHubGetters.swift`
- Current call:
  - `GET https://api.github.com/users/{username}`
- Decoding now uses a typed model (`GitHubUser`) instead of raw JSON
- Verified end-to-end path:
  - credentials -> request -> decode -> watcher manager state update

---

# Learning With AI Progress

## Topic 1: `gh api` in a background-thread app (Software)
- Established architecture direction: local background Swift process while actively working
- Built first end-to-end API call and CLI scaffold

## Topic 2: External screen display (Hardware)
- Goal and output strategy defined
- Implementation pending after software polling loop is stable

---

# Current Gaps and Next Milestones

## Completed (Sprint 2)
- ~~PR and review status endpoints~~ — implemented PR fetch across repos + review-requested search API
- ~~External screen integration and display rendering~~ — serial communication to Arduino LCD implemented
- Poll -> compare -> notify loop — change detection compares display messages between cycles

## Remaining
- Persisted state across restarts
- `--once` mode for single-poll usage
- End-to-end hardware validation with live Arduino + LCD

## Next milestones
1. Validate end-to-end with hardware connected
2. Add state persistence for cross-restart change detection
3. Explore CI status integration as an optional enhancement

