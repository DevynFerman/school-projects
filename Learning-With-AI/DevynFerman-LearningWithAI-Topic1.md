---
marp: true
size: 4:3
paginate: true
title: Learning with AI Using the GitHub API from a Background Swift CLI
---

# Using the GitHub API from a Background Swift CLI

Learning with AI Topic 1
Devyn Ferman | CSC 494

---

## The Problem

I needed a process that could:

- Poll the GitHub API on a timer
- Handle failures without crashing
- Run in the background without blocking my normal workflow

---

## What I Learned: AsyncParsableCommand

`swift-argument-parser` includes `AsyncParsableCommand`, which lets you write the entire program as an `async` function. The polling loop just runs inside `run()`. This is dramatically simpler for solving the asynchronous polling problem than something like Combine or manual thread managment.

```swift
@main
struct GitHubWatcher: AsyncParsableCommand {
    func run() async throws {
        for index in 0..<runCount {
            try await watchManager.getMyPullRequests()
            // ...
            try await usleep(for: .seconds(wait * 60))
        }
    }
}
```

No `DispatchQueue` or `Task Manager`. `async/await` handles it all.

---

## What I Learned: Two Endpoints for Full PR Awareness

GitHub requires two separate endpoints to get the complete picture:

| What you need | Endpoint |
|---|---|
| PRs you authored | `GET /repos/{owner}/{repo}/pulls` |
| PRs requesting your review | `GET /search/issues?q=is:pr+is:open+review-requested:{user}` |

They return different response shapes model and decode them separately.

Use `JSONDecoder` with `.iso8601` date decoding strategy to handle GitHub's date format.

---

## What I Learned: Fetch Once, Poll Often

Not everything needs to be refreshed every cycle.

**Fetch once at startup:**
- User profile (`GET /users/{username}`)
- Repository list

**Refresh every poll cycle:**
- Open pull requests
- Review requests

Repos don't change mid-session, so re-fetching them every 5 minutes wastes API calls and burns toward rate limits. This startup-vs-cycle separation is a common pattern in production polling systems and mirrors some of the systems I use at work.

---

## What I Learned: The Architectural Pivot

**Original plan:** GitHub Action → JSON file → ESP32 polls over WiFi → LCD

**What shipped:** Swift CLI → GitHub API → POSIX serial → Arduino LCD

**Why the change?**
The JSON/WiFi approach added a hosted endpoint, a data format to maintain, and network config on the microcontroller... for a device that only needs to work while I'm at my desk. AI helped me see that all of that complexity wasn't earning its place. The simpler architecture was also the better fit because I'm lazy!

---

## Key Takeaways

1. `AsyncParsableCommand` makes background Swift CLIs surprisingly straightforward. No thread plumbing or publishing required
2. GitHub needs two different endpoints for full PR visibility; know which one returns what
3. Separate startup fetches from poll-cycle fetches to avoid wasted calls and rate limit pressure
4. When an architecture feels complex, it's worth asking whether the complexity is actually earning its keep. Remember to keep it simple, stupid!
